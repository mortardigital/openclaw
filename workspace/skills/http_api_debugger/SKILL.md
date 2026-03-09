---
name: http_api_debugger
description: Diagnose and test HTTP APIs and web services.
metadata:
  openclaw:
    requires:
      bins:
        - curl
        - jq
---
\# HTTP API Debugger
Use this skill when interacting with APIs.
Workflow:
1\. Test endpoint.
curl -v <url>
2\. Inspect headers.
curl -I <url>
3\. Validate JSON.
curl <url> | jq
4\. Test POST request.
curl -X POST -H "Content-Type: application/json" -d '{}' <url>
Rules:
\- Always inspect HTTP status codes.
\- Log request and response.
\- Never assume API responses.
