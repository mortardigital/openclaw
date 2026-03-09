param(
    [string]$Script
)

if (-not $Script) {
    Write-Host "Usage: .\run-ser.ps1 scriptname.py"
    exit
}

docker exec -it openclaw-python-runner-1 python "/work/$Script"
