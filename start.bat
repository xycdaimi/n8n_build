@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Always run from the directory where this script lives (repo root).
cd /d "%~dp0"

set "ENV_FILE=.env"

if not exist "%ENV_FILE%" (
  echo "[ERROR] Missing %ENV_FILE%. Copy .env.example to .env"
  echo "        copy .env.example .env"
  exit /b 1
)

rem Load KEY=VALUE pairs from .env into current process environment.
rem - Ignores blank lines
rem - Ignores comment lines starting with '#'
rem - Accepts optional leading 'export '
for /f "usebackq eol=# delims=" %%A in ("%ENV_FILE%") do (
  set "LINE=%%A"

  rem Skip empty/whitespace-only lines
  for /f "tokens=* delims= " %%B in ("!LINE!") do set "LINE=%%B"
  if "!LINE!"=="" (
    rem noop
  ) else (
    if /i "!LINE:~0,7!"=="export " set "LINE=!LINE:~7!"
    for /f "tokens=1* delims==" %%K in ("!LINE!") do (
      set "KEY=%%K"
      set "VAL=%%L"
      if not "!KEY!"=="" (
        set "!KEY!=!VAL!"
      )
    )
  )
)

docker compose --env-file "%ENV_FILE%" up -d --build --remove-orphans
exit /b %ERRORLEVEL%