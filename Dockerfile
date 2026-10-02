# Sử dụng Tomcat 9 nhưng chạy trên nền Java 17 (để sửa lỗi version 61.0)
FROM tomcat:9.0-jdk17-openjdk-slim

# Build version: 2026-10-02-Zalo-0388520391
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ GitHub vào thư mục chạy web
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8080
EXPOSE 8080

# Chạy Server
CMD ["catalina.sh", "run"]