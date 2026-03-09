import json
import os
import subprocess
from http.server import BaseHTTPRequestHandler, HTTPServer

WORKDIR = os.environ.get("WORKDIR", "/work")
TOKEN = os.environ.get("RUNNER_TOKEN", "")
HOST = os.environ.get("RUNNER_HOST", "0.0.0.0")
PORT = int(os.environ.get("RUNNER_PORT", "8000"))
TIMEOUT_SECS = int(os.environ.get("RUNNER_TIMEOUT_SECS", "120"))

def _json(handler, code, payload):
    body = json.dumps(payload).encode("utf-8")
    handler.send_response(code)
    handler.send_header("Content-Type", "application/json; charset=utf-8")
    handler.send_header("Content-Length", str(len(body)))
    handler.end_headers()
    handler.wfile.write(body)

def _auth_ok(handler):
    if not TOKEN:
        return True  # allow if no token configured (not recommended)
    auth = handler.headers.get("Authorization", "")
    return auth == f"Bearer {TOKEN}"

def _safe_script_name(name: str) -> bool:
    # Only allow scripts in workspace root; no paths, no traversal.
    if not name or not name.endswith(".py"):
        return False
    if "/" in name or "\\" in name:
        return False
    if ".." in name:
        return False
    return True

class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        # Reduce noise
        return

    def do_GET(self):
        if self.path == "/health":
            return _json(self, 200, {"ok": True})
        return _json(self, 404, {"error": "not found"})

    def do_POST(self):
        if not _auth_ok(self):
            return _json(self, 401, {"error": "unauthorized"})

        if self.path != "/run":
            return _json(self, 404, {"error": "not found"})

        try:
            length = int(self.headers.get("Content-Length", "0"))
            raw = self.rfile.read(length) if length > 0 else b"{}"
            req = json.loads(raw.decode("utf-8"))
        except Exception as e:
            return _json(self, 400, {"error": f"bad json: {e}"})

        script = req.get("script", "")
        args = req.get("args", [])
        if not isinstance(args, list):
            return _json(self, 400, {"error": "args must be a list"})

        if not _safe_script_name(script):
            return _json(self, 400, {"error": "script must be a .py filename in workspace root (no paths)"})

        script_path = os.path.join(WORKDIR, script)
        if not os.path.isfile(script_path):
            return _json(self, 404, {"error": f"script not found: {script}"})

        cmd = ["python", script_path, *[str(a) for a in args]]

        try:
            p = subprocess.run(
                cmd,
                cwd=WORKDIR,
                capture_output=True,
                text=True,
                timeout=TIMEOUT_SECS,
            )
            return _json(self, 200, {
                "ok": p.returncode == 0,
                "returncode": p.returncode,
                "stdout": p.stdout,
                "stderr": p.stderr,
            })
        except subprocess.TimeoutExpired:
            return _json(self, 408, {"ok": False, "error": f"timeout after {TIMEOUT_SECS}s"})
        except Exception as e:
            return _json(self, 500, {"ok": False, "error": str(e)})

if __name__ == "__main__":
    httpd = HTTPServer((HOST, PORT), Handler)
    print(f"[runner] listening on http://{HOST}:{PORT} (workdir={WORKDIR})")
    httpd.serve_forever()
