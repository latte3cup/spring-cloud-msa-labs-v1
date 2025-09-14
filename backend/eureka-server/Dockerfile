# ---- Build stage ----
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# 캐시 최적화: 래퍼/의존 파일 먼저
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

# 산출물 이름을 인자화(또는 정확한 파일명으로 교체)
ARG JAR_FILE=/app/build/libs/*SNAPSHOT.jar
COPY --from=build ${JAR_FILE} /app/app.jar

# 비루트 사용자
RUN groupadd -r eureka && useradd -r -g eureka eureka \
 && chown -R eureka:eureka /app
USER eureka

# K8s에서 probe를 쓸 것이므로 curl/HEALTHCHECK는 생략
EXPOSE 8761
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
