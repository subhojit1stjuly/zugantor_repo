@echo off
SETLOCAL EnableDelayedExpansion
SET "ERROR_COUNT=0"
SET "WORKSPACE_ROOT=%~dp0"

echo ========================================
echo Zugantor Monorepo Setup
echo ========================================
echo.

REM Add common SDK paths to PATH
IF EXIST "%LOCALAPPDATA%\Pub\Cache\bin" SET "PATH=%PATH%;%LOCALAPPDATA%\Pub\Cache\bin"
IF EXIST "%APPDATA%\Pub\Cache\bin" SET "PATH=%PATH%;%APPDATA%\Pub\Cache\bin"

REM Add Flutter to PATH if it exists in common locations
FOR %%G IN (
    "C:\flutter\bin"
    "%LOCALAPPDATA%\flutter\bin"
    "%USERPROFILE%\flutter\bin"
    "%USERPROFILE%\development\flutter\bin"
) DO (
    IF EXIST "%%~G" SET "PATH=%%~G;%PATH%"
)

REM Check if Flutter is installed
echo [1/5] Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    exit /b 1
)
flutter --version
echo.

REM Check if Dart is installed
echo [2/5] Checking Dart installation...
where dart >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Dart is not installed or not in PATH
    echo Please install Dart from https://dart.dev/get-dart
    exit /b 1
)
dart --version
echo.

REM Install Melos globally
echo [3/5] Installing Melos...
call dart pub global activate melos
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install Melos
    SET /A ERROR_COUNT+=1
) else (
    echo [SUCCESS] Melos installed successfully
)
echo.

REM Bootstrap and generate
echo [4/5] Bootstrapping workspace and generating code...
cd "%WORKSPACE_ROOT%"
call melos bootstrap
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to bootstrap workspace
    SET /A ERROR_COUNT+=1
) else (
    echo [SUCCESS] Workspace bootstrapped successfully
    echo Running code generation...
    call melos run generate
)
echo.

REM Format and analyze
echo [5/5] Running format and analyze...
call melos run format
if %ERRORLEVEL% NEQ 0 (
    SET /A ERROR_COUNT+=1
)

call melos run analyze
if %ERRORLEVEL% NEQ 0 (
    SET /A ERROR_COUNT+=1
)
echo.

echo ========================================
echo Setup Summary
echo ========================================
if %ERROR_COUNT% GTR 0 (
    echo [WARNING] Setup completed with %ERROR_COUNT% warnings
) else (
    echo [SUCCESS] Setup completed successfully
)
echo.

echo Available commands:
echo - melos run generate        : Generate code once
echo - melos run generate:watch  : Watch and generate code
echo - melos run format         : Format code
echo - melos run analyze        : Analyze code
echo - melos run test           : Run tests
echo - melos run build:apps     : Build all applications
echo.

echo Next steps:
echo 1. Update the API URLs in:
echo    packages/zugantor_core/lib/src/config/environment.dart
echo 2. Run 'melos run build:apps' to build all applications
echo 3. Review README.md for more information
echo.

cd "%WORKSPACE_ROOT%"

if %ERROR_COUNT% GTR 0 (
    exit /b 1
) else (
    exit /b 0
)

ENDLOCAL