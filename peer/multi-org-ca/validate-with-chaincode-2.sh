# Test case #2 for validating the setup
# Requires: Orderer, acme peer1 & acme peer2 to be available
# Install the chaincode on peers. Instantiate on one of the peers
# Now invoke on one peer & query the status on the other peer to 
# validate consistency of the reported state.
#
# 1. Installs the CC to peer1 & peer2
# 2. Instantiates CC on peer1
# 3. Executes query on peer2
# 4. Executes invoke on peer1
# 5. Executes query on peer2

CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
CC_NAME="gocc"
CC_PATH="chaincode_example02"
CC_VERSION="1.0"
CC_CHANNEL_ID="airlinechannel"

ORG_NAME="acme"
IDENTITY="admin"



# 1. Install CC
echo "====> 1   Installing chaincode (may fail if CC/version already there)"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

PEER_NAME="peer2"
PEER_BASE_PORT=8050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

# 2. Instantiate the chaincode on peer1
echo "====> 2   Instantiating chaincode (may fail if CC/version already instantiated)"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR

# 3. Executes query on peer2
echo "====> 3   Querying for value of A in peer2"
PEER_NAME="peer2"
PEER_BASE_PORT=8050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'

# 4. Executes invoke on peer1
echo "====> 4   Execute invoke on peer1 - Transfer 10 from A=>B"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode invoke -C $CC_CHANNEL_ID -n gocc  -c '{"Args":["invoke","a","b","10"]}'

# Give some time for transaction to propagate the network
sleep 3s

# 5. Executes query on peer2
echo "====> 5   Querying for value of A in peer2"
PEER_NAME="peer2"
PEER_BASE_PORT=8050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'