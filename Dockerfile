FROM maven:eclipse-temurin

RUN pip install git

WORKDIR /home