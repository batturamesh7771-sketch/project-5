@echo off
setlocal
echo ======================================================================
echo   PROJECT 5: AERO-X1 / GE90-115B TURBOFAN ENGINE
echo   PUSH TO GITHUB: https://github.com/batturamesh7771-sketch/project-5
echo ======================================================================
echo.

set "GIT_EXE=C:\Users\user\AppData\Local\Programs\PortableGit\cmd\git.exe"
cd /d "C:\Users\user\.gemini\antigravity\scratch\project-5"

echo [1/3] Verifying local repository...
"%GIT_EXE%" status --short

echo.
echo [2/3] Setting remote origin...
"%GIT_EXE%" remote remove origin 2>nul
"%GIT_EXE%" remote add origin https://github.com/batturamesh7771-sketch/project-5.git
"%GIT_EXE%" remote -v

echo.
echo [3/3] Pushing to GitHub (branch: main)...
"%GIT_EXE%" push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ======================================================================
    echo   SUCCESS! Project 5 is live at:
    echo   https://github.com/batturamesh7771-sketch/project-5
    echo ======================================================================
) else (
    echo.
    echo ----------------------------------------------------------------------
    echo   If push failed, please make sure you have:
    echo   1. Created the empty repo 'project-5' at: https://github.com/new
    echo   2. Authenticated with your GitHub account:
    echo      gh auth login
    echo ----------------------------------------------------------------------
)
echo.
pause
