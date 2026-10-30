@echo off
chcp 65001 >nul
echo ======================================================
echo    DONG GOI DU AN THANH FILE ROOT.war
echo ======================================================

echo.
echo [BUOC 1/2] Dong bo co so du lieu song tu may chu...
if exist "sync_live_data.ps1" (
    powershell -ExecutionPolicy Bypass -File ".\sync_live_data.ps1"
)
echo.

set "JAR_CMD="
if exist "C:\Program Files\Java\jdk-21\bin\jar.exe" set "JAR_CMD=C:\Program Files\Java\jdk-21\bin\jar.exe"
if not defined JAR_CMD if exist "C:\Program Files\Java\jdk-23\bin\jar.exe" set "JAR_CMD=C:\Program Files\Java\jdk-23\bin\jar.exe"
if not defined JAR_CMD set "JAR_CMD=jar"

echo [BUOC 2/2] Dang dong goi ROOT.war voi co so du lieu moi nhat...
"%JAR_CMD%" -cvf ROOT.war index.jsp tc.jsp admin.jsp admin.html tuan.jpg WEB-INF META-INF

if %errorlevel% equ 0 (
    copy /y ROOT.war "..\ROOT.war" >nul
    echo.
    echo ======================================================
    echo [THANH CONG] Da tao file ROOT.war va sao chep ra thu muc goc!
    echo ======================================================
) else (
    echo.
    echo [LOI] Dong goi that bai!
)

echo.
pause
