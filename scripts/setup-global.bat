@echo off
:: setup-global.bat
:: วางไฟล์นี้ไว้ที่ E:\My-claude-skill\My-claude-skill\scripts\
:: แล้วรันจาก Command Prompt

setlocal

:: --- กำหนด path ---
set REPO_DIR=E:\My-claude-skill\My-claude-skill
set SOURCE=%REPO_DIR%\global-config\CLAUDE.md
set CLAUDE_DIR=%USERPROFILE%\.claude
set TARGET=%CLAUDE_DIR%\CLAUDE.md

:: --- สร้างโฟลเดอร์ถ้ายังไม่มี ---
if not exist "%REPO_DIR%\global-config" (
    mkdir "%REPO_DIR%\global-config"
    echo สร้างโฟลเดอร์ global-config แล้ว
)

if not exist "%CLAUDE_DIR%" (
    mkdir "%CLAUDE_DIR%"
    echo สร้างโฟลเดอร์ .claude แล้ว
)

:: --- copy CLAUDE.md จาก Downloads เข้า global-config ---
if not exist "%SOURCE%" (
    if exist "%USERPROFILE%\Downloads\CLAUDE.md" (
        copy "%USERPROFILE%\Downloads\CLAUDE.md" "%SOURCE%"
        echo copy CLAUDE.md จาก Downloads เข้า global-config แล้ว
    ) else (
        echo ไม่พบ CLAUDE.md ใน Downloads หรือ global-config
        echo กรุณาวาง CLAUDE.md ไว้ที่ %SOURCE% ก่อนรัน script นี้
        pause
        exit /b 1
    )
)

:: --- backup ของเดิมถ้ามี ---
if exist "%TARGET%" (
    copy "%TARGET%" "%TARGET%.bak" >nul
    echo backup ไฟล์เดิมไว้ที่ %TARGET%.bak
)

:: --- copy เข้า .claude ---
copy "%SOURCE%" "%TARGET%" >nul
echo linked: %SOURCE% → %TARGET%

:: --- push ขึ้น git ---
cd /d "%REPO_DIR%"
git add global-config\CLAUDE.md scripts\setup-global.bat
git commit -m "feat: add global CLAUDE.md with model strategy and conventions"
git push

echo.
echo เสร็จแล้ว — CLAUDE.md พร้อมใช้งานใน Claude Code
pause
