# Install Process described here is OK for TEST Setup only
# DO NOT USE THIS FOR Production level Setups
# Sets up a single node Kafka cluster

Installation
============
> cd setup/kafka
> ./install.sh
This will install Kafka binaries in the folder $HOME/kafka

Launch
======
> cd setup/kafka
> start.sh
Check the logs - $HOME/kafka.log

Shutdown
========
> cd setup/kafka
> stop.sh

Edit server.properties
======================
> nano $HOME/kafka/config/server.properties
Add the line to it: delete.topic.enable=true

Validate
========
1. Check if Zookeeper is Up
>  telnet localhost 2181
Type 'ruok'
You should get a response 'iamok'

2. Publish a message
echo "Hello, World" | ~/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic TestTopic > /dev/null

3. Subscribe to a message
~/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic TestTopic --from-beginning

Kafka Frequently Used Scripts
==============================
https://gist.github.com/vkroz/05136cefdbb4fa61296993db17e1ae3f

export ZK_HOSTS="localhost:2181"

$HOME/kafka/bin/kafka-topics.sh --zookeeper $ZK_HOSTS --list
$HOME/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic TestTopic
$HOME/kafka/bin/kafka-topics.sh --zookeeper $ZK_HOSTS --delete --topic TestTopic
$HOME/kafka/bin/kafka-configs.sh --zookeeper $ZK_HOSTS --entity-type topics --entity-name TestTopic --describe


