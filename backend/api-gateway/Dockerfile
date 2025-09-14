# ---- Build stage ----
FROM gradle:8.5-jdk17 AS build
WORKDIR /app

COPY settings.gradle build.gradle ./ 
COPY gradle gradle
COPY gradlew ./ 
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon || true

COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# JAR 복사 (SNAPSHOT jar 패턴)
COPY --from=build /app/build/libs/*SNAPSHOT.jar /app/app.jar

RUN groupadd -r apigateway && useradd -r -g apigateway apigateway \
 && chown -R apigateway:apigateway /app
USER apigateway

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
