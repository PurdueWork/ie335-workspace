@echo off
set CMD=%~1
if "%CMD%"=="" set CMD=pull
if /i "%CMD%"=="sync" goto :sync
if /i "%CMD%"=="pull" goto :pull
echo Usage: %~nx0 [pull^|sync]  (default: pull)
pause
exit /b 1

:pull
echo Git PULL
echo ========
goto :run_pull

:sync
echo Git SYNC - Pull then Push
echo =========================
goto :run_pull

:run_pull
REM Check if we're in a git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo No Git repository found in current directory.
    pause
    exit /b 1
)

echo.
echo Pulling latest changes from remote...
git pull

if errorlevel 1 (
    echo.
    echo Pull failed. You may have merge conflicts or need to set upstream.
    pause
    exit /b 1
)

if /i "%CMD%"=="pull" (
    echo.
    echo Done! Your local branch is up to date with the remote.
    pause
    exit /b 0
)

echo.
echo Pushing local commits to remote...
git push

if errorlevel 1 (
    echo.
    echo Push failed. Check remote URL and permissions.
    pause
    exit /b 1
)

echo.
echo Done! Local and remote are in sync.
pause
exit /b 0
