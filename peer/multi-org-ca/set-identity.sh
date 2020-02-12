# Sets the identity used for executing the peer commands
function usage {
    echo 'USAGE:  . set-identity.sh  ORG_NAME [IDENTITY default=admin]'
}

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    IDENTITY="admin"
else
    IDENTITY=$2
fi

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=`pwd`/../../ca/multi-org-ca/client

export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp

# Setup the MSP ID
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

echo "Switched Identity to: $ORG_NAME   $IDENTITY"

# Simply checks if this script was executed directly on the terminal/shell
# it has the '.'
if [[ $0 = *"set-identity.sh" ]]
then
    echo "Did you use the . before ./set-identity.sh? If yes then we are good :)"
fi