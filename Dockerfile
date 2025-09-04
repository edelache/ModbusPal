FROM openjdk:16-jdk-alpine

ARG JYTHON_VERSION=2.7.0
ARG JYTHON_HOME=/usr/src/jython-$JYTHON_VERSION

ENV JYTHON_VERSION=$JYTHON_VERSION
ENV JYTHON_HOME=$JYTHON_HOME
ENV PATH=$PATH:$JYTHON_HOME/bin

RUN apk update

RUN set -eux && \
    apk add --no-cache bash wget zip apache-ant fontconfig ttf-dejavu openjdk8 && \
    ln -sf /bin/bash /bin/sh

WORKDIR /usr/src

RUN wget -cO ivy.zip https://dlcdn.apache.org//ant/ivy/2.5.1/apache-ivy-2.5.1-bin-with-deps.zip && \
    unzip ivy.zip && \
    rm -f ivy.zip

RUN wget https://repo1.maven.org/maven2/org/python/jython-installer/2.7.4/jython-installer-2.7.4.jar && \
    java -jar jython-installer-2.7.4.jar -s -d /usr/local/jython && \
    export JYTHON_HOME=/usr/local/jython && export PATH="/usr/local/jython/bin:$PATH" && \
    echo 'export JYTHON_HOME=/usr/local/jython' >> ~/.profile && echo 'export PATH="/usr/local/jython/bin:$PATH"' >> ~/.profile

WORKDIR /usr/src/app
COPY . .

RUN ant compile -lib ../apache-ivy-2.5.1/ivy-2.5.1.jar
RUN ant jar -lib ../apache-ivy-2.5.1/ivy-2.5.1.jar

WORKDIR /usr/src/app/
