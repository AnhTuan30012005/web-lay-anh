# Sử dụng Tomcat 9 nhưng chạy trên nền Java 17 (để sửa lỗi version 61.0)
FROM tomcat:9.0-jdk17-openjdk-slim

# Xóa các ứng dụng mặc định của Tomcat cho nhẹ
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ GitHub vào thư mục chạy web
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8080
EXPOSE 8080

# Chạy Server
CMD ["catalina.sh", "run"]