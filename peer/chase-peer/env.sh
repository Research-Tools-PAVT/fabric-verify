
# All config stored under the configtxgen folder
export  CONFIG_DIRECTORY=$PWD/../../orderer/multi-org-banks

export FABRIC_CFG_PATH=$PWD

# Change this to an appropriate level
# v1.4 changed the logging
# export CORE_LOGGING_LEVEL=INFO
export FABRIC_LOGGING_SPEC=INFO

# Variables for setting peer addresses
export CORE_PEER_LISTENADDRESS=localhost:8051
export CORE_PEER_ADDRESS=localhost:8051


# Change this to folder for managing the ledger
# You may use the following to point to the current folder
# Be aware that GoLevelDB does not work well with mounted file systems so you may see
# errors in using the folder that is on host system.

#export CORE_PEER_FILESYSTEMPATH=./ledger

export CORE_PEER_FILESYSTEMPATH=$HOME/ledgers/peer/chase/ledger

# Identity set to Admin

export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/chase.com/users/Admin@chase.com/msp


# State Data persistence in CouchDB
CORE_LEDGER_STATE_STATEDATABASE=couchdb
CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=localhost:5984
#CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=
#CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=

export NODECHAINCODE=/vagrant/nodechaincode
export GOCHAINCODE=/vagrant/gopath/src

if [[ $0 = *"env.sh" ]]
then
    echo "STOP: Looks like you forgot the . before ./env.sh? "
else
    #./show-env.sh
    echo "Done."
fi
