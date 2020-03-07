#!/bin/bash
# Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
export CC_NAME="gocc"
export CC_PATH="chaincode_example02"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="airlinechannel"


# Use this for testing your cloud setup *or* even local setup :)
# Example ./cc-test.sh  install  
function    usage {
    echo  "Usage: ./cc-test.sh    install | instantiate | invoke | query "
    echo  "Installs the GoLang CC to specified Organization"
}


OPERATION=$1
echo "CC Operation : $OPERATION    for   Org: $ORG_CONTEXT"
#Check if the TLS is enabled
TLS_PARAMETERS=""
if [ "$CORE_PEER_TLS_ENABLED" == "true" ]; then
   echo "*** Executing with TLS Enabled ***"
   TLS_PARAMETERS=" --tls true --cafile $ORDERER_CA_ROOTFILE"
fi


# Invoke the "peer chain code" command using the operation
case $OPERATION in
    "noop")
              # Used for setting the environment variables
              # Usage:  .       ./bins/cc-test.sh  
              #         source  ./binscc-test.sh
              echo "No-Opertaion!!"
        ;;
    "install")   
              peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

              peer chaincode list --installed -C airlinechannel
        ;;
    "instantiate")
              peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR $TLS_PARAMETERS

              #peer chaincode list --instantiated -C airlinechannel
        ;;
    "query")
            echo -n "query a="
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'
            echo -n "query b="
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","b"]}'
        ;;
    
    "invoke")
            echo "Invoke sending 5 token from a=>b"
            peer chaincode invoke -C $CC_CHANNEL_ID -n gocc  -c '{"Args":["invoke","a","b","5"]}' $TLS_PARAMETERS -o $ORDERER_ADDRESS
        ;;

    *) usage
esac



