#!/bin/bash
# Usage:  ./init-setup.sh [tls]
# If the $1 = "tls" then Orderer and Peers are launched with TLS enabled
# By default the TLS is DISABLED

DOCK_FOLDER=$PWD

echo    "====>Cleanup the earlier runs"
./clean.sh all

echo    "====>Generating the crypto"
cd config

if [ "$1" == "raft" ]; then 
    # For RAFT we will generate crypto for 5 orderer instances
    cryptogen generate --config=../raft/crypto-config.yaml
else 
    cryptogen generate --config=crypto-config.yaml
fi

echo    "====>Generating the genesis block"
export FABRIC_CFG_PATH=$PWD
if [ "$1" == "raft" ]; then 
    # Use the confitx.yaml under raft subfolder
    export FABRIC_CFG_PATH=$PWD/../raft
fi
configtxgen -outputBlock  ./orderer/airlinegenesis.block -channelID ordererchannel  -profile AirlineOrdererGenesis


echo    "====>Generating the channel create tx"
configtxgen -outputCreateChannelTx  airlinechannel.tx -channelID airlinechannel  -profile AirlineChannel

# Back to docker foder
cd $DOCK_FOLDER

echo    "====>Launching the containers"
./launch.sh $1


echo    "====>Setting up anchor peers for Acme & Budget"

# Why this sleep is needed for RAFT?
# Since 3 RAFT orderers are needed we need to give enough time for orderers to elect a leader. If leader is not 
# elected channel creation will Fail; In which case you may need to increase the sleep duartion.
if [ "$1" == "raft" ]; then
    sleep 5s
fi

bins/run-all.sh $1

echo    "===Done===Execute tests with   ./test-all.sh   $1"