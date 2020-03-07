#!/bin/bash
#Dumps the current context
echo "ORG_CONTEXT=$ORG_CONTEXT"
echo "FABRIC_CFG_PATH=$FABRIC_CFG_PATH"
echo "ORDERER_ADDRESS=$ORDERER_ADDRESS"
env | grep CORE_