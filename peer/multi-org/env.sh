# Extract name of the ORG from the folder name
ORG_NAME="${PWD##*/}"
ORG_PWD=$PWD

# All config stored under the configtxgen folder
export  CONFIG_DIRECTORY=$ORG_PWD/../../../orderer/multi-org

# export FABRIC_CFG_PATH=$PWD

# Change this to an appropriate level
# v1.4 does not support
# export CORE_LOGGING_LEVEL=DEBUG
export FABRIC_LOGGING_SPEC=DEBUG


# Variables for setting peer addresses
# export CORE_PEER_LISTENADDRESS=localhost:7051
# export CORE_PEER_ADDRESS=localhost:7051


# Change this to folder for managing the ledger
# You may use the following to point to the current folder
# Be aware that GoLevelDB does not work well with mounted file systems so you may see
# errors in using the folder that is on host system.
#export CORE_PEER_FILESYSTEMPATH=./ledger
#export CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/acme/ledger
export CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger

#export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/peers/devpeer/msp

#export CORE_PEER_LOCALMSPID=AcmeMSP

# State Data persistence in CouchDB
#CORE_LEDGER_STATE_STATEDATABASE=goleveldb
#CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=localhost:5984
#CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=
#CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=

export GOPATH=/vagrant/gopath

export NODECHAINCODE=/vagrant/nodechaincode

