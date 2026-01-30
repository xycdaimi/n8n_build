@echo off
setlocal EnableExtensions

rem Always run from the directory where this script lives (repo root).
cd /d "%~dp0"

if exist ".env" (
  docker compose --env-file ".env" down --remove-orphans
) else (
  docker compose down --remove-orphans
)
exit /b %ERRORLEVEL%