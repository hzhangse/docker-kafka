#!/bin/bash
sudo docker run -d \
--name kafka1 \
--publish 9092:9092 --publish 7203:7203 \
--env KAFKA_ADVERTISED_HOST_NAME=172.19.0.24 \
-e KAFKA_BROKER_ID=0 \
-e KAFKA_DEFAULT_REPLICATION_FACTOR=2 \
-e JMX_PORT=7203 \
-e KAFKA_DELETE_TOPIC_ENABLE=true \
-e KAFKA_NUM_PARTITIONS=3 \
-e ZOOKEEPER_CONNECTION_STRING=172.19.0.21:2181,172.19.0.22:2181,172.19.0.23:2181 \
--net shadownet --ip 172.19.0.24   registry.cn-hangzhou.aliyuncs.com/rainbow954/kafka:latest
#--restart=always 
#--volume /home/ryan/work/tools/docker/kafka/docker-kafka-master/data1:/data --volume /home/ryan/work/tools/docker/kafka/docker-kafka-master/logs1:/logs \

sudo docker run -d \
--name kafka2 \
--env KAFKA_ADVERTISED_HOST_NAME=172.19.0.25 \
-e KAFKA_BROKER_ID=1 \
-e KAFKA_DEFAULT_REPLICATION_FACTOR=2 \
-e JMX_PORT=7203 \
-e KAFKA_DELETE_TOPIC_ENABLE=true \
-e KAFKA_NUM_PARTITIONS=3 \
-e ZOOKEEPER_CONNECTION_STRING=172.19.0.21:2181,172.19.0.22:2181,172.19.0.23:2181 \
--net shadownet --ip 172.19.0.25   registry.cn-hangzhou.aliyuncs.com/rainbow954/kafka:latest


sudo docker run -d \
--name kafka3 \
--env KAFKA_ADVERTISED_HOST_NAME=172.19.0.26 \
-e KAFKA_BROKER_ID=2 \
-e KAFKA_DEFAULT_REPLICATION_FACTOR=2 \
-e JMX_PORT=7203 \
-e KAFKA_DELETE_TOPIC_ENABLE=true \
-e KAFKA_NUM_PARTITIONS=3 \
-e ZOOKEEPER_CONNECTION_STRING=172.19.0.21:2181,172.19.0.22:2181,172.19.0.23:2181 \
--net shadownet --ip 172.19.0.26  registry.cn-hangzhou.aliyuncs.com/rainbow954/kafka:latest


