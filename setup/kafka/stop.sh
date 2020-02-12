#!/bin/bash
# Shutsdown kafka

# Stop Kafka
$HOME/kafka/bin/kafka-server-stop.sh

# Stop Zookeeper
sudo service zookeeper stop

echo "Done."
