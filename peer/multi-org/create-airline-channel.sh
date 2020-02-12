# The Policy for App Channel Creation = MAJORITY of Admins
# This utility leads to signing of the airline channel txn file by acme & budget
CONFIG_FOLDER=`pwd`/../../orderer/multi-org
CRYPTO_FOLDER=$CONFIG_FOLDER/crypto-config

function signChannelTxFile {
    FABRIC_CFG_PATH=`pwd`/$ORG_NAME
    CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/users/Admin@$ORG_NAME.com/msp
    CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger
    peer channel signconfigtx -f $CONFIG_FOLDER/airline-channel.tx
}

# Sign the Airline-Channel Tx file as acme
ORG_NAME=acme
export FABRIC_CFG_PATH=$PWD/$ORG_NAME
signChannelTxFile
echo "Signed the tx as Acme"

# Sign the Airline-Channel Tx file as budget
ORG_NAME=budget
export FABRIC_CFG_PATH=$PWD/$ORG_NAME
signChannelTxFile
echo "Signed the tx as Budget"

peer channel create -o localhost:7050 -c airlinechannel -f $CONFIG_FOLDER/airline-channel.tx
