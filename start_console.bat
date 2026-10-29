@echo off
setlocal
echo ======================================================================
echo PANOPTICON SENTINEL UI — ENTERPRISE WEB CONSOLE
echo Lead Architect: Aditya Singh (Roll: K064)
echo ======================================================================
set PORT=8787
set MANAGER_URL=http://127.0.0.1:8788
set TOKEN=mock-analyst-token

set /p MODE="Select mode [1 = Live Manager Proxy (:8788), 2 = Standalone Offline Mode]: "
if "%MODE%"=="2" (
    echo [*] Starting in Standalone Offline Mode with alerts.ndjson on port %PORT%...
    python app.py --port %PORT% --alerts-file alerts.ndjson
) else (
    echo [*] Starting in Live Manager Proxy Mode pointing to %MANAGER_URL% on port %PORT%...
    set PANOPTICON_MANAGER_TOKEN=%TOKEN%
    python app.py --port %PORT% --manager-url %MANAGER_URL%
)
pause
