param(
    [string]$Message = "Agent update"
)

$ErrorActionPreference = "Stop"

Set-Location "C:\openclaw"

Write-Host "== Checking git state =="

if ((Test-Path ".git\rebase-merge") -or (Test-Path ".git\rebase-apply") -or (Test-Path ".git\MERGE_HEAD")) {
    throw "Git rebase or merge already in progress."
}

$changes = git status --porcelain
if (-not $changes) {
    throw "No changes detected."
}

Write-Host "== Running lightweight validation =="

# Python syntax check for runner
if (Test-Path ".\python-runner\runner_service.py") {
    python -m py_compile .\python-runner\runner_service.py
}

# Docker Compose validation
docker compose config | Out-Null

# Require at least one skill file to exist
$skillFiles = Get-ChildItem ".\workspace\skills" -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue
if (-not $skillFiles) {
    throw "No SKILL.md files found under workspace\skills"
}

# Check only added lines for likely secret assignments, not mere mentions
$workingDiff = git diff --unified=0
$stagedDiff = git diff --cached --unified=0
$allDiff = "$workingDiff`n$stagedDiff"

$addedLines = $allDiff -split "`n" | Where-Object {
    $_ -match '^\+' -and
    $_ -notmatch '^\+\+\+'
}

$secretRegexes = @(
    'PYRUNNER_TOKEN\s*[:=]\s*.+',
    'OPENCLAW_GATEWAY_TOKEN\s*[:=]\s*.+',
    'CLAUDE_AI_SESSION_KEY\s*[:=]\s*.+',
    'CLAUDE_WEB_SESSION_KEY\s*[:=]\s*.+',
    'CLAUDE_WEB_COOKIE\s*[:=]\s*.+',
    'TELEGRAM_BOT_TOKEN\s*[:=]\s*.+',
    'telegram_bot_token\s*[:=]\s*.+',
    'ghp_[A-Za-z0-9_]+',
    'github_pat_[A-Za-z0-9_]+'
)

foreach ($line in $addedLines) {
    foreach ($regex in $secretRegexes) {
        if ($line -match $regex) {
            throw "Possible secret detected in added line: $line"
        }
    }
}

Write-Host "== Creating branch =="

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$branch = "agent/$timestamp"

git fetch origin
git checkout -b $branch

Write-Host "== Staging approved paths only =="

git add .gitignore
git add docker-compose.yml
git add Dockerfile.python
git add docker
git add python-runner
git add run-ser.ps1
git add openclaw.NOT_USED.empty.json
git add workspace\skills
git add workspace\AGENTS.md
git add workspace\SOUL.md
git add workspace\TOOLS.md

$staged = git diff --cached --name-only
if (-not $staged) {
    throw "No approved files staged."
}

Write-Host "== Commit =="
git commit -m $Message

Write-Host "== Push =="
git push -u origin $branch

Write-Host ""
Write-Host "Done."
Write-Host "Branch pushed: $branch"
Write-Host "Open a pull request into main."