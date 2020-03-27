#!/bin/bash

CHANNEL_NAME="$1"
DELAY="$2"
CC_SRC_LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
SEQ=2
NO_CHAINCODE="$6"
: ${CHANNEL_NAME:="payzchannel"}
: ${DELAY:="3"}
: ${CC_SRC_LANGUAGE:="go"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
: ${NO_CHAINCODE:="false"}
CC_SRC_LANGUAGE=`echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=20
PACKAGE_ID=""

CC_RUNTIME_LANGUAGE=golang
CC_SRC_PATH="github.com/hyperledger/fabric-samples/chaincode/cross-payment/"

echo "Channel name : "$CHANNEL_NAME

# import utils
. scripts/utils.sh

if [ "${NO_CHAINCODE}" != "true" ]; then

	## at first we package the chaincode
	packageChaincode $SEQ 0 1

	## Install chaincode on peer0.org1 and peer0.org2
	echo "Installing chaincode on peer0.org1..."
	installChaincode 0 1
	echo "Install chaincode on peer0.org2..."
	installChaincode 0 2

	## query whether the chaincode is installed
	queryInstalled 0 1

	## approve the definition for org1
	approveForMyOrg $SEQ 0 1

	## check whether the chaincode definition is ready to be committed
        ## expect org1 to have approved and org2 not to
	checkCommitReadiness $SEQ 0 1 "\"Org1MSP\": true" "\"Org2MSP\": false"
	checkCommitReadiness $SEQ 0 2 "\"Org1MSP\": true" "\"Org2MSP\": false"

	## now approve also for org2
	approveForMyOrg $SEQ 0 2

	## check whether the chaincode definition is ready to be committed
	## expect them both to have approved
	checkCommitReadiness $SEQ 0 1 "\"Org1MSP\": true" "\"Org2MSP\": true"
	checkCommitReadiness $SEQ 0 2 "\"Org1MSP\": true" "\"Org2MSP\": true"

	## now that we know for sure both orgs have approved, commit the definition
	commitChaincodeDefinition $SEQ 0 1 0 2

	## query on both orgs to see that the definition committed successfully
	queryCommitted $SEQ 0 1
	queryCommitted $SEQ 0 2

	# invoke init
	chaincodeInvoke 1 0 1 0 2

echo "This is build : " $SEQ
fi
