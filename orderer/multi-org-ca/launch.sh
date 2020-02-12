# Use this script for overriding ORDERER Parameters
export FABRIC_CFG_PATH=$PWD

# export ORDERER_FILELEDGER_LOCATION="/var/ledgers/multi-org-ca/orderer/ledger" 
export ORDERER_FILELEDGER_LOCATION="/home/vagrant/ledgers/multi-org-ca/orderer/ledger" 

mkdir -p log

LOG_FILE=./log/orderer.log

sudo -E orderer 2> $LOG_FILE &

echo "===> Done.  Please check logs under   $LOG_FILE"

