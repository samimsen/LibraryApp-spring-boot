# ---- Build stage ----
FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /app

# Önce pom.xml (cache için)
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Sonra kaynak kod
COPY src ./src

# Jar üret
RUN mvn -DskipTests clean package

# ---- Runtime stage ----
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
