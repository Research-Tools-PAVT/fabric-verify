# Sign the airline channel tx file org admins
# E.g.,   ./sign-channel-tx.sh   acme       Signs the file with acme admin certificate/key
# E.g.,   ./sign-channel-tx.sh   budget     Signs the file with budget admin certificate/key
function usage {
    echo "./sign-channel-tx.sh   ORG_NAME"
    echo "               Signs the channel transaction file with identity of admin from ORG_ADMIN"
    echo "               PLEASE NOTE:  Signs the tx file under  orderer/multi-org-ca/airline-channel.tx "
}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# Set the environment variable $1 = ORG_NAME Identity=admin
source set-identity.sh 


# Variable holds path to the channel tx file
CHANNEL_TX_FILE=$PWD/../../orderer/multi-org-ca/airline-channel.tx

# Execute command to sign the tx file in place
peer channel signconfigtx -f $CHANNEL_TX_FILE

echo "====> Done. Signed file with identity $ORG_NAME/admin"
echo "====> Check size & timestamp of file $CHANNEL_TX_FILE"

# PS: The join cannot be execute without a channel created
# peer channel join -o localhost:7050 -b $PWD/../../orderer/multi-org-ca/airline-channel.tx