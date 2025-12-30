# --- GIAI ĐOẠN 1: Build bằng Maven (Dùng Java 17) ---
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# --- GIAI ĐOẠN 2: Chạy Tomcat (Dùng Java 17) ---
# Quan trọng: Đã đổi từ jdk11 sang jdk17 để sửa lỗi version 61.0
FROM tomcat:9.0-jdk17-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]