FROM tomcat:9
# Take the war and copy to webapps of tomcat
COPY ./webapp/target/*.war /usr/local/tomcat/webapps/
