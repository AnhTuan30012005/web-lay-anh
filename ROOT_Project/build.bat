@echo off
chcp 65001 >nul
echo ======================================================
echo    BIÊN DỊCH DỰ ÁN JAVA WEB (ROOT_Project)
echo ======================================================

set "JAVAC_CMD=javac"
where javac >nul 2>nul
if %errorlevel% neq 0 (
    if exist "C:\Program Files\Java\jdk-21\bin\javac.exe" (
        set "JAVAC_CMD=C:\Program Files\Java\jdk-21\bin\javac.exe"
    ) else if exist "C:\Program Files\Java\jdk-23\bin\javac.exe" (
        set "JAVAC_CMD=C:\Program Files\Java\jdk-23\bin\javac.exe"
    ) else (
        echo [LOI] Khong tim thay trinh bien dich javac. Vui long cai dat JDK!
        pause
        exit /b 1
    )
)

echo Dang bien dich tcController.java (tuong thich Java 17+)...
"%JAVAC_CMD%" --release 17 -encoding UTF-8 -cp "WEB-INF\lib\servlet-api.jar" -d "WEB-INF\classes" "src\Controller\tcController.java"

if %errorlevel% equ 0 (
    echo.
    echo ======================================================
    echo [THANH CONG] Da bien dich xong vao WEB-INF\classes!
    echo ======================================================
) else (
    echo.
    echo [LOI] Bien dich that bai! Vui long kiem tra loi ben tren.
)

echo.
pause
