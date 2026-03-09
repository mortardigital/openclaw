---
name: python_lint_typing
description: Run Python linting and static type checks before executing code.
metadata:
  openclaw:
    requires:
      bins:
        - ruff
        - mypy
        - pyright
        - python3
---
# Python Lint + Type Check Workflow
Use this skill whenever Python code is created or modified.
Workflow:
1. Run linting first:
ruff .
2. Run static type checking:
mypy .
3. Run deep type analysis:
pyright
4. Only proceed to execution or testing if these pass.
Rules:
- Never claim code is valid unless linting and type checks have been executed.
- Prefer fixing root causes rather than suppressing warnings.
- Keep code compatible with Python 3.12.