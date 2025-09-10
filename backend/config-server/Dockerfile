# ---- Build stage ----
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

# Gradle 캐시 최적화
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

# 빌드 결과 복사
ARG JAR_FILE=/app/build/libs/*SNAPSHOT.jar
COPY --from=build ${JAR_FILE} /app/app.jar

# config-repo 폴더 포함 (Native 모드 사용 시)
COPY ../config-repo /config-repo

# 비루트 사용자
RUN groupadd -r configserver && useradd -r -g configserver configserver \
 && chown -R configserver:configserver /app /config-repo
USER configserver

# K8s 프로브가 담당하므로 HEALTHCHECK, curl 설치 불필요 → 제거
EXPOSE 8888
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
