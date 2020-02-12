# Utility for executing the commands on different peers
# Change this to an appropriate level
# v1.4 does not support
# export CORE_LOGGING_LEVEL=INFO
export FABRIC_LOGGING_SPEC=INFO

source ./unsetcore.sh

function usage {
    echo 'To setup the environment'
    echo 'Usage:  ./set-env.sh  org-name <identity>'
}

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 1
else
    ORG_NAME=$1
    echo "Switching Identity for Org = $ORG_NAME"
fi

export FABRIC_CFG_PATH=`pwd`/$ORG_NAME
# export CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger

export GOPATH=/vagrant/gopath
export NODECHAINCODE=/vagrant/nodechaincode

# Set the identity
. ./set-identity.sh $ORG_NAME $2