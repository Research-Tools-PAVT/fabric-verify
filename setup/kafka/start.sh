#!/bin/bash
# Launches Kafka server

# Start the zookeeper
sudo service zookeeper start

# Give time for zookeeper to launch
sleep 3s

# Start the kafka
nohup $HOME/kafka/bin/kafka-server-start.sh $HOME/kafka/config/server.properties > $HOME/kafka.log 2>&1 &

echo "Check logs for errors - $HOME/kafka.log"
echo "Done."