#----------------------------------
# Stage 1 - Build
#----------------------------------

# Import docker image with maven installed
FROM maven:3.8.3-openjdk-17 AS builder

# Add labels instead of deprecated MAINTAINER
LABEL maintainer="Arun Mahajan <arunmahajan9240@gmail.com>"
LABEL app="bankapp"

# Set working directory
WORKDIR /src

# Copy source code from local to container
COPY . .

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2 - Deploy
#--------------------------------------

# Import small size java image
FROM openjdk:17-alpine AS deployer

# Copy build from stage 1 (builder)
COPY --from=builder /src/target/*.jar /bankapp.jar

# Expose application port
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/bankapp.jar"]
