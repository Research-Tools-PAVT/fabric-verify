# ORG_NAME="${PWD##*/}"
CRYPTO_CONFIG_DIRECTORY=`pwd`/../../orderer/multi-org/crypto-config
if [ -z $1 ]
then
    echo 'Please provide Org Name!!!    Usage: ./launch-peer.sh  org-name'
    exit 1
else 
    ORG_NAME=$1
fi

# source ./unsetcore.sh

echo "Launching peer for $ORG_NAME "

cd $ORG_NAME

export FABRIC_CFG_PATH=`pwd`
echo $FABRIC_CFG_PATH
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_DIRECTORY/peerOrganizations/$ORG_NAME.com/peers/devpeer/msp
export CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger

peer node start 2> peer.log &
