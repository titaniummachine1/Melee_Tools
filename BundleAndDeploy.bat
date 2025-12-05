@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "TITLEFILE=title.txt"
set "BUILD_DIR=%BUNDLE_OUTPUT_DIR%"
if "%BUILD_DIR%"=="" set "BUILD_DIR=%SCRIPT_DIR%build"

rem Ensure build directory exists
if not exist "%BUILD_DIR%\" mkdir "%BUILD_DIR%"

rem Run bundler (ensuring bundle.js sees BUNDLE_OUTPUT_DIR)
pushd "%SCRIPT_DIR%" >nul
set "BUNDLE_OUTPUT_DIR=%BUILD_DIR%"
node "%SCRIPT_DIR%bundle.js"
if errorlevel 1 (
  echo [BundleAndDeploy] Bundle step failed. Aborting.
  exit /b 1
)
popd >nul

rem Determine actual output file name from title.txt or default
set "OUTFILE=Melee_Tools.lua"
if exist "%SCRIPT_DIR%%TITLEFILE%" (
  set /p OUTFILE=<"%SCRIPT_DIR%%TITLEFILE%"
)
if "%OUTFILE%"=="" set "OUTFILE=Melee_Tools.lua"

set "BUNDLE_PATH=%BUILD_DIR%\%OUTFILE%"

if not exist "%BUNDLE_PATH%" (
  echo [BundleAndDeploy] Expected bundle "%BUNDLE_PATH%" not found.
  exit /b 1
)

set "_BUNDLE_READY="
for /L %%I in (1,1,20) do (
  if exist "%BUNDLE_PATH%" (
    for %%F in ("%BUNDLE_PATH%") do if %%~zF GTR 0 set "_BUNDLE_READY=1"
  )
  if defined _BUNDLE_READY goto :bundle_ready
  timeout /T 1 >nul
)

echo [BundleAndDeploy] Bundle "%BUNDLE_PATH%" not ready after waiting.
exit /b 1

:bundle_ready

set "DEPLOY_DIR=%localappdata%\lua"
if not exist "%DEPLOY_DIR%" (
  echo [BundleAndDeploy] Creating %DEPLOY_DIR%
  mkdir "%DEPLOY_DIR%"
)

copy /Y "%BUILD_DIR%\%OUTFILE%" "%DEPLOY_DIR%\%OUTFILE%" >nul
if errorlevel 1 (
  echo [BundleAndDeploy] Deployment failed. Ensure %DEPLOY_DIR% is writable.
  exit /b 1
)

echo [BundleAndDeploy] Deployed to %DEPLOY_DIR%\%OUTFILE%

rem Run auto-commit if changes exceed threshold
node "%SCRIPT_DIR%auto-commit.js"
if errorlevel 1 (
  echo [BundleAndDeploy] Auto-commit step had errors (non-fatal)
)

endlocal
exit /b 0