# Use official Tomcat base image
FROM tomcat:9.0-jdk17

# Remove the default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file to the webapps directory as ROOT.war (or keep the name)
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Optional: expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
