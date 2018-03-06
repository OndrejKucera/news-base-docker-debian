## Sources - https://github.com/P7h/docker-spark
#
# Debian strech - jre8u151

FROM openjdk:8u151-jre-stretch
MAINTAINER Ondrej Kucera <ondra.kuca@gmail.com>

# Scala related variables.
ARG SCALA_VERSION=2.11.12
ARG SCALA_BINARY_ARCHIVE_NAME=scala-${SCALA_VERSION}
ARG SCALA_BINARY_DOWNLOAD_URL=https://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_BINARY_ARCHIVE_NAME}.tgz

# SBT related variables.
ARG SBT_VERSION=1.1.0
ARG SBT_BINARY_ARCHIVE_NAME=sbt-${SBT_VERSION}
ARG SBT_BINARY_DOWNLOAD_URL=https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/${SBT_BINARY_ARCHIVE_NAME}.tgz

# Maven related variables
ARG MVN_VERSION=3.5.2
ARG MVN_BINARY_ARCHIVE_NAME=apache-maven-${MVN_VERSION}
ARG MVN_BINARY_DOWNLOAD_URL=http://www-us.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/${MVN_BINARY_ARCHIVE_NAME}-bin.tar.gz

# Spark related variables.
ARG SPARK_VERSION=2.3.0
ARG SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop2.7
ARG SPARK_BINARY_DOWNLOAD_URL=http://apache.cs.utah.edu/spark/spark-${SPARK_VERSION}/${SPARK_BINARY_ARCHIVE_NAME}.tgz

# Configure env variables for Scala, SBT and Spark.
# Also configure PATH env variable to include binary folders of Java, Scala, SBT and Spark.
ENV SCALA_HOME  /usr/local/scala
ENV SBT_HOME    /usr/local/sbt
ENV MVN_HOME    /usr/local/mvn
ENV SPARK_HOME  /usr/local/spark
ENV PATH        $JAVA_HOME/bin:$SCALA_HOME/bin:$SBT_HOME/bin:$MVN_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# Download, uncompress and move all the required packages and libraries to their corresponding directories in /usr/local/ folder.
RUN apt-get -yqq update && \
    apt-get install -yqq vim less screen tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    wget -qO - ${SCALA_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    wget -qO - ${SBT_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    wget -qO - ${MVN_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    wget -qO - ${SPARK_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && \
    cd /usr/local/ && \
    ln -s ${SCALA_BINARY_ARCHIVE_NAME} scala && \
    ln -s ${MVN_BINARY_ARCHIVE_NAME} mvn && \
    ln -s ${SPARK_BINARY_ARCHIVE_NAME} spark && \
    cp spark/conf/log4j.properties.template spark/conf/log4j.properties && \
    sed -i -e s/WARN/ERROR/g spark/conf/log4j.properties && \
    sed -i -e s/INFO/ERROR/g spark/conf/log4j.properties
