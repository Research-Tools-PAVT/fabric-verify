#!/bin/bash
#Sets the context for native peer commands

function usage {
    echo "Usage:             . ./set-context.sh  ORG_NAME"
    echo "Usage with TLS     . ./set-context.sh  ORG_NAME  tls"
    echo "           Sets the organization context for native peer execution"
}

if [ "$1" == "" ]; then
    usage
    exit
fi

export ORG_CONTEXT=$1
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_CONTEXT:0:1})${ORG_CONTEXT:1}"
export ORG_NAME=$MSP_ID

# Added this Oct 22
export CORE_PEER_LOCALMSPID=$ORG_NAME"MSP"

# Logging specifications
export FABRIC_LOGGING_SPEC=INFO

# Location of the core.yaml
export FABRIC_CFG_PATH=$PWD/config/$1

# Address of the peer
export CORE_PEER_ADDRESS=peer1.$1.com:7051

if [ "$ORG_CONTEXT" == "budget" ]; then
    # Native binary uses the local port on VM 
    export CORE_PEER_ADDRESS=peer1.$1.com:8051
fi

# Local MSP for the admin - Commands need to be executed as org admin
export CORE_PEER_MSPCONFIGPATH=$PWD/config/crypto-config/peerOrganizations/$1.com/users/Admin@$1.com/msp

# Address of the orderer
export ORDERER_ADDRESS=orderer.acme.com:7050

# RAFT requires TLS
if [ "$2" == "tls" ] || [ "$2" == "raft" ] ; then

    export ORDERER_CA_ROOTFILE=$PWD/config/crypto-config/ordererOrganizations/acme.com/orderers/orderer.acme.com/msp/tlscacerts/tlsca.acme.com-cert.pem

    export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/config/crypto-config/peerOrganizations/$1.com/peers/peer1.$1.com/tls/ca.crt

    export CORE_PEER_TLS_ENABLED=true
else
    export CORE_PEER_TLS_ENABLED=false
fi

