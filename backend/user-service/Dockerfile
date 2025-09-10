# User Service — Dockerfile (EKS용 권장)
# 1) Build stage
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# 캐시 최적화: 의존성 먼저 복사
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

# 빌드 산출물 복사 (JAR 파일명에 맞춰 ARG 조정 가능)
ARG JAR_FILE=/app/build/libs/*.jar
COPY --from=build ${JAR_FILE} /app/app.jar

# non-root 사용자 생성 및 권한 설정
RUN groupadd -r user && useradd -r -g user user \
 && chown -R user:user /app
USER user

# K8s에서 Probe를 사용하므로 Docker HEALTHCHECK 제거
EXPOSE 8081

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
