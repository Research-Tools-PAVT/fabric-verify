# This script simply submits the channel create transaction transaction
function usage {
    echo    "Usage:     ./submit-create-channel   ORG_NAME  [IDENTITY default=admin]  [ORDERER_ADDRESS default=localhost:7050]"
    echo    "           Uses the Organization Identity provided to submit transaction"
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
    IDENTITY=admin
else 
    IDENTITY=$2
fi

# Orderer address
if [ -z $3 ]
then
    ORDERER_ADDRESS="localhost:7050"
    echo "====>Using default orderer localhost:7050"
else 
    ORDERER_ADDRESS=$3
fi

# Channel transaction file location
# The transaction should have been signed by one or more admins based on policy
CHANNEL_TX_FILE="$PWD/../../orderer/multi-org-ca/airline-channel.tx"

# Sets the environment variables for the given identity
source set-identity.sh  

# Submit the channel create transation
peer channel create -o $ORDERER_ADDRESS -c airlinechannel -f $CHANNEL_TX_FILE

echo "====> Done. Check Orderer logs for any errors !!!"

















