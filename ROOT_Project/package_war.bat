@echo off
chcp 65001 >nul
echo ======================================================
echo    DONG GOI DU AN THANH FILE ROOT.war
echo ======================================================

echo.
echo [BƯỚC 1/2] Đồng bộ cơ sở dữ liệu sống từ máy chủ trước khi đóng gói...
if exist "sync_live_data.ps1" (
    powershell -ExecutionPolicy Bypass -File ".\sync_live_data.ps1"
)
echo.

set "JAR_CMD=jar"
where jar >nul 2>nul
if %errorlevel% neq 0 (
    if exist "C:\Program Files\Java\jdk-21\bin\jar.exe" (
        set "JAR_CMD=C:\Program Files\Java\jdk-21\bin\jar.exe"
    ) else if exist "C:\Program Files\Java\jdk-23\bin\jar.exe" (
        set "JAR_CMD=C:\Program Files\Java\jdk-23\bin\jar.exe"
    )
)

echo [BƯỚC 2/2] Đang đóng gói ROOT.war với cơ sở dữ liệu mới nhất...
if defined JAR_CMD (
    "%JAR_CMD%" -cvf ROOT.war index.jsp tc.jsp admin.jsp admin.html tuan.jpg WEB-INF META-INF
) else (
    powershell -Command "Compress-Archive -Path 'index.jsp', 'tc.jsp', 'admin.jsp', 'admin.html', 'tuan.jpg', 'WEB-INF', 'META-INF' -DestinationPath 'ROOT.zip' -Force; Move-Item -Path 'ROOT.zip' -Destination 'ROOT.war' -Force"
)

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
