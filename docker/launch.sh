#!/bin/bash
#Launches the setup
if [ "$1" == "tls" ]; then
    echo "********************* Launching with TLS enabled *******************"
    docker-compose -f ./config/docker-compose-base.yaml -f ./tls/docker-compose-tls.yaml up -d
elif [ "$1" == "raft" ]; then
    echo "********************* Launching with TLS RAFT *******************"
    docker-compose -f ./config/docker-compose-base.yaml -f ./tls/docker-compose-tls.yaml -f ./raft/docker-compose-raft.yaml up -d
else 
    #Default launch with TLS disabled
    docker-compose -f ./config/docker-compose-base.yaml up -d
fi