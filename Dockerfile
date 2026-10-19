# Sử dụng Tomcat 9 với Java 17 Temurin (đã fix lỗi cgroup v2 của bản openjdk-slim cũ)
FROM tomcat:9.0-jdk17-temurin

# Build version: 2026-10-19-Reconnect-Google-Sheet
RUN rm -rf /usr/local/tomcat/webapps/*

# Giải nén trực tiếp ROOT.war vào /usr/local/tomcat/webapps/ROOT khi build Docker
COPY ROOT.war /tmp/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    jar -xf /tmp/ROOT.war && \
    rm -f /tmp/ROOT.war && \
    rm -f /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/servlet-api.jar

# -XX:-UseContainerSupport: Bỏ qua đọc cgroup để sửa triệt để lỗi NullPointerException CgroupInfo trên Render/Linux
# -Xms64m -Xmx320m: Giới hạn heap an toàn trong 512MB RAM Free tier
# -XX:+UseSerialGC: Tiết kiệm RAM
# -Djava.security.egd: Tránh treo khởi tạo SecureRandom
ENV JAVA_OPTS="-XX:-UseContainerSupport -Xms64m -Xmx320m -XX:+UseSerialGC -Djava.security.egd=file:/dev/./urandom"

# Mở cả cổng 8080 và 10000
EXPOSE 8080 10000

# Khởi động Tomcat: tự động đổi port trong server.xml nếu Render truyền biến $PORT
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]