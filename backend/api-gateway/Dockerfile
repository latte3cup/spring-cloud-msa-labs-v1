# ---- Build stage ----
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# 캐시 최적화: 의존성 관련 파일 먼저 복사
COPY settings.gradle build.gradle ./
COPY gradle gradle
COPY gradlew ./
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon || true

# 소스 복사 후 빌드
COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# 빌드 산출물을 명시적으로 복사
ARG JAR_FILE=/app/build/libs/*-all.jar
# 만약 jar 이름이 다르면 정확한 이름으로 바꿔라.
COPY --from=build ${JAR_FILE} /app/app.jar

# 비루트(non-root) 사용자 생성 및 권한 설정
RUN groupadd -r apigateway && useradd -r -g apigateway apigateway \
 && chown -R apigateway:apigateway /app
USER apigateway

# K8s에서 프로브를 사용하므로 Docker HEALTHCHECK는 제거
EXPOSE 8080

# 런타임 옵션은 Deployment의 env로 주입하도록 JAVA_OPTS를 비워둠
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
