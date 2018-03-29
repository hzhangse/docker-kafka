#!/bin/bash
sudo docker run -d \
--name kafka-monitor \
 --publish 10080:8080 \
 -it -e ZK=172.19.0.22:2181 \
--net shadownet --ip 172.19.0.27  --restart=always   jpodeszwik/kafka-offset-monitor:0.2.1


sudo docker run -d --name kafka-manager -it   -p 19000:9000 -e ZK_HOSTS="172.19.0.22:2181" -e APPLICATION_SECRET=letmein  --net shadownet --ip 172.19.0.28  --restart=always  sheepkiller/kafka-manager



