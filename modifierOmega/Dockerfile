FROM openjdk:17
ADD target/modifierOmega-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8030
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

