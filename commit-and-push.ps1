param(
    [string]$Message = "",
    [switch]$Force
)

Write-Host "Git Auto Commit and Push Script" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Check if we're in a git repository
try {
    $null = git status --porcelain 2>$null
} catch {
    Write-Host "Error: No Git repository found in current directory." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check for changes
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "No changes to commit." -ForegroundColor Yellow
    exit 0
}

Write-Host "Current status:" -ForegroundColor Green
git status --short
Write-Host ""

# Get commit message
if (-not $Message) {
    $Message = Read-Host "Enter commit message (or press Enter for auto-generated message)"
}

if (-not $Message) {
    $Message = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Write-Host ""
Write-Host "Staging all changes..." -ForegroundColor Yellow
git add .

Write-Host ""
Write-Host "Committing with message: '$Message'" -ForegroundColor Yellow
git commit -m "$Message"

Write-Host ""
Write-Host "Pushing to remote repository..." -ForegroundColor Yellow
git push

Write-Host ""
Write-Host "Done! Changes have been committed and pushed." -ForegroundColor Green

if (-not $Force) {
    Read-Host "Press Enter to exit"
}