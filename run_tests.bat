@echo off
setlocal
echo ======================================================================
echo PANOPTICON SENTINEL UI — AUTOMATED TEST SUITE RUNNER
echo Author: Aditya Singh (Lead Detection & Dashboard Architect, Roll: K064)
echo ======================================================================
echo.
echo [1/2] Running Python Unit & Proxy Security Tests (64 cases)...
python -m unittest discover -s tests -v
if %ERRORLEVEL% neq 0 (
    echo [!] Python Unit Tests FAILED!
    exit /b %ERRORLEVEL%
)

echo.
echo [2/2] Running Node.js End-to-End Tests (49 cases)...
node tests\e2e\runner.js
if %ERRORLEVEL% neq 0 (
    echo [!] Node.js E2E Tests FAILED!
    exit /b %ERRORLEVEL%
)

echo.
echo ======================================================================
echo ALL 113 TESTS PASSED SUCCESSFULLY (100%% PASS RATE)
echo ======================================================================
pause
