---
name: python_execution_sandbox
description: Safely execute Python code inside controlled environments.
metadata:
  openclaw:
    requires:
      bins:
        - python3
---
\# Python Execution Sandbox
Use this skill whenever Python code must be executed.
Workflow:
1\. Validate code first:
ruff .
2\. Run type checks:
mypy .
3\. Execute code in isolated mode:
python -I script.py
Rules:
\- Never run Python scripts directly without lint + type checks.
\- Prefer isolated execution.
\- Avoid modifying system paths.
\- Always capture stdout and stderr.
