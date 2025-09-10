# Order Service — Dockerfile (EKS용 권장)
# 1) Build stage
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# 캐시 최적화: 의존성 관련 파일 먼저
COPY build.gradle settings.gradle gradle.properties ./
COPY gradle gradle
COPY gradlew ./
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon || true

# 소스 복사 후 빌드
COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon

# 2) Runtime stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 산출물 복사 (JAR 이름이 다르면 정확한 파일명으로 변경)
ARG JAR_FILE=/app/build/libs/*.jar
COPY --from=build ${JAR_FILE} /app/app.jar

# non-root 사용자 생성 및 권한 설정
RUN groupadd -r orders && useradd -r -g orders orders \
 && chown -R orders:orders /app
USER orders

# K8s에서 probe가 있어야 하므로 Docker HEALTHCHECK 제거
EXPOSE 8083
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
