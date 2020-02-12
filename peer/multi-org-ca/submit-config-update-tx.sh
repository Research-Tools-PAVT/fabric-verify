# This script simply submits the channel create transaction transaction
function usage {
    echo    "Usage:     ./submit-config-update-tx.sh   ORG_NAME IDENTITY CHANNEL_ID  [ORDERER_ADDRESS default=localhost:7050]"
    echo    "           Uses the Organization Identity provided to submit the 'config update' transaction"
    echo    "           Script will fail if the Orderer is not up !!!"
}

# Org Name is needed
if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# Identity check
if [ -z $2 ]
then
    usage
    echo 'Please provide IDENTITY e.g., admin!!!'
    exit 1
else 
    IDENTITY=$2
fi

# Check the channel id
if [ -z $3 ]
then
    usage
    echo 'Please provide CHANNEL_ID!!!'
    exit 1
else 
    CHANNEL_ID=$3
fi



# Orderer address
if [ -z $4 ]
then
    ORDERER_ADDRESS="localhost:7050"
    echo "====>Using default orderer localhost:7050"
else 
    ORDERER_ADDRESS=$4
fi

# Path to the update config PB

CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB="./config/cfg_update_block_with_envelope.pb"

# Sets the environment variables for the given identity
source set-identity.sh  $ORG_NAME $IDENTITY

# Submit the channel update transation
peer channel update -f $CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB -c $CHANNEL_ID -o $ORDERER_ADDRESS

./show-env.sh

echo "Done. Check Orderer logs for any errors !!!"
echo "VALIDATION: Fetch the latest config and check the parameters ./fetch-config-json.sh"

















