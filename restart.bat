@echo off
setlocal EnableExtensions

rem Always run from the directory where this script lives (repo root).
cd /d "%~dp0"

rem Restart containers WITHOUT rebuilding images
if exist ".env" (
  docker compose --env-file ".env" restart
) else (
  docker compose restart
)

exit /b %ERRORLEVEL%
