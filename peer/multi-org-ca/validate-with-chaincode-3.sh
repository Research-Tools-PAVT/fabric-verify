# Test case #3 for validating the setup
# Ensures that the chaincode state is reflected across the 
# organizations.
#
# Requires: Orderer, acme peer1 & budget-peer1 to be available
# 1. Installs the CC to acme peer1 & budget-peer1
# 2. Instantiates CC on acme peer1
# 3. Executes query on budget-peer1
# 4. Executes invoke on acme peer1
# 5. Executes query on budget-peer1

CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
CC_NAME="gocc"
CC_PATH="chaincode_example02"
CC_VERSION="1.0"
CC_CHANNEL_ID="airlinechannel"





# 1. Install CC on acme peer1 & budget-peer1
echo "====> 1   Installing chaincode (may fail if CC/version already there)"
ORG_NAME="acme"
IDENTITY="admin"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

ORG_NAME="budget"
IDENTITY="admin"
PEER_NAME="budget-peer1"
PEER_BASE_PORT=9050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

# 2. Instantiate the chaincode on acme peer1
echo "====> 2   Instantiating chaincode (may fail if CC/version already instantiated)"
ORG_NAME="acme"
IDENTITY="admin"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR

# 3. Executes query on budget peer1
echo "====> 3   Querying for value of A in budget-peer1"
ORG_NAME="budget"
IDENTITY="admin"
PEER_NAME="budget-peer1"
PEER_BASE_PORT=9050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'

# 4. Executes invoke on acme peer1
echo "====> 4   Execute invoke on acme peer1 - Transfer 10 from A=>B"
ORG_NAME="acme"
IDENTITY="admin"
PEER_NAME="peer1"
PEER_BASE_PORT=7050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode invoke -C $CC_CHANNEL_ID -n gocc  -c '{"Args":["invoke","a","b","10"]}'

# Give some time for transaction to propagate the network
sleep 3s

# 5. Executes query on budget-peer1
echo "====> 5   Querying for value of A in budget-peer1"
ORG_NAME="budget"
IDENTITY="admin"
PEER_NAME="budget-peer1"
PEER_BASE_PORT=9050
source  set-env.sh  $ORG_NAME $PEER_NAME $PEER_BASE_PORT $IDENTITY
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'