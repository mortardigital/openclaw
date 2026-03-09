---
name: python_pytest_workflow
description: Generate and run pytest-based tests for Python code.
metadata:
  openclaw:
    requires:
      bins:
        - pytest
        - python3
---
# Python Pytest Workflow
Use this skill when creating or validating tests for Python code.
Workflow:
1. Inspect the target Python module.
2. Create tests in the `tests/` directory.
3. Prefer deterministic unit tests over broad integration tests.
4. Run tests with:
pytest -q
5. If failures occur:
   - read the failure output
   - propose a minimal fix
   - rerun the tests
Rules:
- Never claim tests pass unless pytest has been executed.
- Prefer fixtures to duplicated setup code.
- Keep tests small and deterministic.