@echo off
echo Git Auto Commit and Push Script
echo ================================

REM Check if there are any changes to commit
git status --porcelain >nul 2>&1
if errorlevel 1 (
    echo No Git repository found in current directory.
    pause
    exit /b 1
)

REM Check if there are any changes
git status --porcelain | findstr . >nul 2>&1
if errorlevel 1 (
    echo No changes to commit.
    pause
    exit /b 0
)

echo Current status:
git status --short
echo.

REM Ask for commit message
set /p commit_msg="Enter commit message (or press Enter for auto-generated message): "

REM If no message provided, use auto-generated one
if "%commit_msg%"=="" (
    set commit_msg=Auto-commit: %date% %time%
)

echo.
echo Staging all changes...
git add .

echo.
echo Committing with message: "%commit_msg%"
git commit -m "%commit_msg%"

echo.
echo Pushing to remote repository...
git push

echo.
echo Done! Changes have been committed and pushed.
pause