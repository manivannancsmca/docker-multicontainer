# ============================================
# Stage 1: Build (keep the full JDK)
# ============================================
FROM eclipse-temurin:25-jdk-alpine AS builder

RUN apk add --no-cache maven

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:resolve dependency:resolve-plugins -B

COPY src/ src/

RUN mvn package -DskipTests -B \
    && mv target/*.jar target/app.jar

# ============================================
# Stage 2: Runtime
# ============================================
FROM eclipse-temurin:25-jre-alpine

# Install curl for health checks, create non-root user
RUN apk add --no-cache curl && \
    addgroup -S appgroup && \
    adduser -S appuser -G appgroup -h /home/appuser

WORKDIR /app

COPY --from=builder /build/target/app.jar /app/app.jar

RUN mkdir -p /app/logs && chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

ENV JAVA_OPTS="-XX:+UseG1GC \
    -XX:MaxRAMPercentage=75.0 \
    -XX:InitialRAMPercentage=50.0 \
    -XX:+UseStringDeduplication \
    -Djava.security.egd=file:/dev/./urandom"

HEALTHCHECK --interval=15s --timeout=5s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]