# Sử dụng Tomcat 9 nhưng chạy trên nền Java 17 (để sửa lỗi version 61.0)
FROM tomcat:9.0-jdk17-openjdk-slim

# Build version: 2026-10-19-Fix-Render-OOM-Port
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR vào thư mục chạy web
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Giới hạn heap JVM: tránh OOM trên Render Free tier (512MB RAM)
ENV JAVA_OPTS="-Xms64m -Xmx320m -XX:+UseSerialGC -Djava.security.egd=file:/dev/./urandom"

# Mở cả cổng 8080 và 10000
EXPOSE 8080 10000

# Khởi động Tomcat: tự động đổi port trong server.xml nếu Render truyền biến $PORT
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]