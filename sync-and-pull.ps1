param(
    [Parameter(Position = 0)]
    [ValidateSet("pull", "sync")]
    [string]$Command = "pull",
    [switch]$Force
)

$isSync = ($Command -eq "sync")

Write-Host "Git $($Command.ToUpper())" -ForegroundColor Cyan
Write-Host ("=" * (6 + $Command.Length))

# Check if we're in a git repository
try {
    $null = git rev-parse --git-dir 2>$null
} catch {
    Write-Host "Error: No Git repository found in current directory." -ForegroundColor Red
    if (-not $Force) { Read-Host "Press Enter to exit" }
    exit 1
}

Write-Host ""
Write-Host "Pulling latest changes from remote..." -ForegroundColor Yellow
git pull

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Pull failed. You may have merge conflicts or need to set upstream." -ForegroundColor Red
    if (-not $Force) { Read-Host "Press Enter to exit" }
    exit 1
}

if ($isSync) {
    Write-Host ""
    Write-Host "Pushing local commits to remote..." -ForegroundColor Yellow
    git push
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "Done! Local and remote are in sync." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Push failed. Check remote URL and permissions." -ForegroundColor Red
        if (-not $Force) { Read-Host "Press Enter to exit" }
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "Done! Your local branch is up to date with the remote." -ForegroundColor Green
}

if (-not $Force) {
    Read-Host "Press Enter to exit"
}
