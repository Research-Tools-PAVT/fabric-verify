# Test case #1 for validating the setup
# Requires the acme peer1 to be up & running
#
# 1. Installs the chaincode on peer1
# 2. Instantiates the chaincode on peer1
# 3. Executes the Invoke & Query on peer1

# export CORE_LOGGING_LEVEL=warning
export FABRIC_LOGGING_SPEC=WARNING

CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
CC_NAME="gocc"
CC_PATH="chaincode_example02"
CC_VERSION="1.0"
CC_CHANNEL_ID="airlinechannel"

ORG_NAME="acme"
IDENTITY="admin"

SLEEP_TIME=3s

# 1. Set the identity context
source  set-identity.sh  $ORG_NAME  $IDENTITY

# 2. Install the chaincode

echo "====> Step 2   Installing chaincode (may fail if CC/version already there)"
peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION

# 3. Instantiate the chaincode
echo "====> Step 3     Setting A=100  B=100  (may fail if already instantiated)"
peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR


# 4. Execute Query
echo "====> Step 4     Querying A"
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'


# 5. Invoke Query
echo "====> Step 5     Transferring 10 from A to B"
peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["invoke","a","b","10"]}'
sleep $SLEEP_TIME

# 6. Execute Query
echo "====> Step 6     Querying A"
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'
