FROM tomcat:latest

RUN apt-get update

RUN apt-get install -y openjdk-11-jre-headless

RUN java --version

COPY ./webapp/target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"
