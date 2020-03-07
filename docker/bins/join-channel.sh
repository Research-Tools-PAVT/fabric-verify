#!/bin/bash
#After running this script confirm that peer has joined
#by running peer channel list
#Check if the TLS is enabled
TLS_PARAMETERS=""
if [ "$CORE_PEER_TLS_ENABLED" == "true" ]; then
   echo "*** Executing with TLS Enabled ***"
   TLS_PARAMETERS=" --tls true --cafile $ORDERER_CA_ROOTFILE"
fi

peer channel join   -b ./config/airlinechannel.block -o $ORDERER_ADDRESS $TLS_PARAMETERS

