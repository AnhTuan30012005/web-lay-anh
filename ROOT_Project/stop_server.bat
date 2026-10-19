@echo off
chcp 65001 >nul
echo Dang tat may chu Tomcat...

set "TOMCAT_DIR=D:\nam ba\ki_1\java_nangcao\apache-tomcat-9.0.99-windows-x64\apache-tomcat-9.0.99"
if not defined JAVA_HOME (
    if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    ) else if exist "C:\Program Files\Java\jdk-23" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-23"
    )
)

cd /d "%TOMCAT_DIR%\bin"
call shutdown.bat
echo Da gui lenh tat Tomcat.
