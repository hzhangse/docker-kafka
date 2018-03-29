# Builds an image for Apache Kafka 0.8.1.1 from binary distribution.
#
# The netflixoss/java base image runs Oracle Java 8 installed atop the
# ubuntu:trusty (14.04) official image. Docker's official java images are
# OpenJDK-only currently, and the Kafka project, Confluent, and most other
# major Java projects test and recommend Oracle Java for production for optimal
# performance.

FROM netflixoss/java:8


# The Scala 2.11 build is currently recommended by the project.
ENV KAFKA_VERSION=1.1.0 KAFKA_SCALA_VERSION=2.12 JMX_PORT=7203
ENV KAFKA_RELEASE_ARCHIVE kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz

RUN mkdir /kafka /data /logs
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates
RUN apt-get install  -y openssh-server
# Download Kafka binary distribution
ADD https://dist.apache.org/repos/dist/release/kafka/${KAFKA_VERSION}/${KAFKA_RELEASE_ARCHIVE} /tmp/
ADD https://dist.apache.org/repos/dist/release/kafka/${KAFKA_VERSION}/${KAFKA_RELEASE_ARCHIVE}.md5 /tmp/

WORKDIR /tmp

# Check artifact digest integrity
RUN echo VERIFY CHECKSUM: && \
  gpg --print-md MD5 ${KAFKA_RELEASE_ARCHIVE} 2>/dev/null && \
  cat ${KAFKA_RELEASE_ARCHIVE}.md5

# Install Kafka to /kafka
RUN tar -zx -C /kafka --strip-components=1 -f ${KAFKA_RELEASE_ARCHIVE} && \
  rm -rf kafka_*

ADD config /kafka/config
ADD start.sh /start.sh
RUN chmod a+x /start.sh 

# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里  
RUN useradd admin  
RUN echo "admin:admin" | chpasswd  
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers  

# Set up a user to run Kafka
RUN groupadd kafka && \
  useradd -d /kafka -g kafka  kafka && \
  chown -R kafka:kafka /kafka /data /logs
RUN echo "kafka:kafka" | chpasswd  
RUN echo "kafka   ALL=(ALL)       ALL" >> /etc/sudoers  
USER kafka
ENV PATH /kafka/bin:$PATH
WORKDIR /kafka



# broker, jmx
EXPOSE 9092 ${JMX_PORT}
VOLUME [ "/data", "/logs" ]

CMD ["/start.sh"]

