# Joins the peer to a channel
# ORG_NAME="${PWD##*/}"
echo "Script will FAIL if peer for $ORG_NAME not up !!!"
GENESIS_BLOCK=./airlinechannel.block

CRYPTO_FOLDER=$PWD/../../orderer/multi-org/crypto-config
if [ -z $1 ]
then
    echo 'Please provide Org Name!!!    Usage: ./join-channel.sh  org-name'
    exit 1
else 
    ORG_NAME=$1
fi

cd $ORG_NAME


FABRIC_CFG_PATH=$PWD
CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger
CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/users/Admin@$ORG_NAME.com/msp

if [ -f "$GENESIS_BLOCK" ]
then
	echo "Block file found."
else
	echo "Getting the Block file."
    # peer channel fetch config $GENESIS_BLOCK -o localhost:7050 -c airlinechannel
    # Fetch the genesis block i.e., the 0th block for the channel
    peer channel fetch 0  $GENESIS_BLOCK -o localhost:7050 -c airlinechannel
fi


# Join the channel
peer channel join -o localhost:7050 -b $GENESIS_BLOCK

# Wait for the channel to get created
echo    "Update anchor peer ... please wait!!"
sleep   5s

ANCHOR_UPDATE_TX="$PWD/../../../orderer/multi-org/airline-anchor-update-$ORG_NAME.tx"
peer channel update -o localhost:7050 -c airlinechannel -f $ANCHOR_UPDATE_TX
