# Sets the identity to specified   Org   User

# Extract name of the ORG from the folder name
#ORG_NAME="${PWD##*/}"
#ORG_PWD=`pwd`

function usage {
    echo 'To setup identity - execute in the org directory'
    echo '../set-identity.sh  org-name [User? | admin | peer <peer-name>]'
}

echo "Current Identity: $CORE_PEER_MSPCONFIGPATH"

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 1
else
    ORG_NAME=$1
    echo "Switching Identity for Org = $ORG_NAME"
fi

if [ -z $2 ];
then
    usage
    echo  'Setting default identity!!'
    IDENTITY='admin'
else
    IDENTITY=$2
fi

# Create the path to the crypto config folder
CRYPTO_FOLDER=`pwd`/../../orderer/multi-org/crypto-config

PEER_NAME='devpeer'
#CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/peers/$PEER_NAME/msp

case $IDENTITY in 
    "peer")
        CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/peers/$PEER_NAME/msp
        ;;
    "admin")
        CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/users/Admin@$ORG_NAME.com/msp
        ;;
    *)
        CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/users/$IDENTITY@$ORG_NAME.com/msp
        ;;
esac

export CORE_PEER_MSPCONFIGPATH

echo "Switched Identity to: $IDENTITY"
echo $CORE_PEER_MSPCONFIGPATH