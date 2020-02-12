#!/bin/bash

# MUST provide 2 args 
# $1 = Path to configtx.yaml   $2 = asOrg  Acme \ Budget

#Check if the TLS is enabled
TLS_PARAMETERS=""
if [ "$CORE_PEER_TLS_ENABLED" == "true" ]; then
   echo "*** Executing with TLS Enabled ***"
   TLS_PARAMETERS=" --tls true --cafile $ORDERER_CA_ROOTFILE"
fi

PEER_FABRIC_CFG_PATH=$FABRIC_CFG_PATH

FABRIC_CFG_PATH=./config

configtxgen -outputAnchorPeersUpdate ./config/peer-update.tx   -asOrg $ORG_NAME -channelID airlinechannel  -profile AirlineChannel

FABRIC_CFG_PATH=$PEER_FABRIC_CFG_PATH

peer channel update -f ./config/peer-update.tx -c airlinechannel -o $ORDERER_ADDRESS $TLS_PARAMETERS

