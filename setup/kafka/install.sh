#!/bin/bash
# Installs Kafka under the $HOME folder
# Location of binaries => $HOME/kafka/bin

# Update
sudo apt-get update

# Install JRE
sudo apt-get --assume-yes install default-jre

# Install Zookeepr
sudo apt-get --assume-yes install zookeeperd
# Stop zookeeper and prevent it from auto starting
sudo service zookeeper stop
sudo systemctl remove zookeeper

# Create a temp directory
mkdir $HOME/kafka
cd $HOME/kafka
#wget http://apache.claz.org/kafka/1.1.0/kafka_2.12-1.1.0.tgz -O kafka.tgz
# wget http://www-us.apache.org/dist/kafka/1.1.0/kafka_2.12-1.1.0.tgz
# Updated v1.3-3
# wget http://www-us.apache.org/dist/kafka/1.1.1/kafka_2.12-1.1.1.tgz

# Updated v1.4-3.1
wget http://www-us.apache.org/dist/kafka/2.1.1/kafka_2.12-2.1.1.tgz

mv *.tgz  kafka.tgz

# Untar & delete tar file
tar -xvzf ./kafka.tgz --strip 1
rm kafka.tgz

