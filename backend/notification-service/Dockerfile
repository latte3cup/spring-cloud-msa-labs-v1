# Notification Service — Dockerfile (EKS용, 권장)
# 1) Build stage
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# 캐시 최적화: 의존성 먼저
COPY settings.gradle build.gradle gradle.properties ./
COPY gradle gradle
COPY gradlew ./
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon || true

# 소스 복사 후 빌드
COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon

# 2) Runtime stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 결과 복사 (JAR 이름에 맞게 수정)
ARG JAR_FILE=/app/build/libs/*.jar
COPY --from=build ${JAR_FILE} /app/app.jar

# non-root 사용자 생성 및 권한 설정
RUN groupadd -r notification && useradd -r -g notification notification \
 && chown -R notification:notification /app
USER notification

# K8s에서 Probe를 쓰므로 Docker HEALTHCHECK 제거
EXPOSE 8085
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
