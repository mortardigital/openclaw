---
name: git_safe_workflow
description: Safe git operations and repository management.
metadata:
  openclaw:
    requires:
      bins:
        - git
---
\# Git Safe Workflow
Use this skill when interacting with git repositories.
Workflow:
1\. Check repository status.
git status
2\. Review changes.
git diff
3\. Stage files carefully.
git add <file>
4\. Commit changes.
git commit -m "<message>"
5\. Push changes.
git push
Rules:
\- Never use force push.
\- Never rewrite history unless instructed.
\- Always inspect diffs before commit.
