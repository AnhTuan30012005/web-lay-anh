@echo off
chcp 65001 >nul
echo ======================================================
echo       KHỞI ĐỘNG MÁY CHỦ TOMCAT (ROOT_Project)
echo ======================================================

set "TOMCAT_DIR=D:\nam ba\ki_1\java_nangcao\apache-tomcat-9.0.99-windows-x64\apache-tomcat-9.0.99"

if not defined JAVA_HOME (
    if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    ) else if exist "C:\Program Files\Java\jdk-23" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-23"
    )
)

echo Dang dong bo ma nguon moi nhat vao Tomcat...
xcopy /Y /Q "index.jsp" "%TOMCAT_DIR%\webapps\ROOT\" >nul
xcopy /Y /Q "tc.jsp" "%TOMCAT_DIR%\webapps\ROOT\" >nul
xcopy /Y /Q "tuan.jpg" "%TOMCAT_DIR%\webapps\ROOT\" >nul
xcopy /Y /E /Q "WEB-INF\classes" "%TOMCAT_DIR%\webapps\ROOT\WEB-INF\classes\" >nul

echo.
echo Dang khoi dong Tomcat tren cong 8080...
echo Sau khi khoi dong xong, truy cap dia chi:
echo ==^> http://localhost:8080/
echo.

cd /d "%TOMCAT_DIR%\bin"
start "Apache Tomcat 9.0 - Tuan Hoa Photo" cmd /k "catalina.bat run"

echo Da mo cua so Tomcat thanh cong!
echo.
