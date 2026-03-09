param(
    [string]$Message = "Agent update"
)

$ErrorActionPreference = "Stop"

Write-Host "== Checking git state =="

if ((Test-Path ".git\rebase-merge") -or (Test-Path ".git\rebase-apply") -or (Test-Path ".git\MERGE_HEAD")) {
    throw "Git rebase or merge already in progress."
}

$changes = git status --porcelain
if (-not $changes) {
    throw "No changes detected."
}

Write-Host "== Running lightweight validation =="

docker compose config | Out-Null

Write-Host "== Creating branch =="

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$branch = "agent/$timestamp"

git fetch origin
git checkout -b $branch

Write-Host "== Staging approved paths only =="

git add safe-agent-push.ps1
git add workspace\skills
git add workspace\AGENTS.md
git add workspace\SOUL.md
git add workspace\TOOLS.md
git add docker
git add python-runner
git add docker-compose.yml
git add Dockerfile.python
git add .gitignore

$staged = git diff --cached --name-only

if (-not $staged) {
    throw "No approved files staged."
}

Write-Host "== Committing =="

git commit -m $Message

Write-Host "== Pushing =="

git push -u origin $branch

Write-Host ""
Write-Host "Branch pushed: $branch"
Write-Host "Open a pull request on GitHub."