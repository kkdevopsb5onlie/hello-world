# Use official Tomcat base image
FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT application (optional, if you don’t want Tomcat default app)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat's webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
