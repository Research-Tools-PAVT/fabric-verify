# Launches the Orderer

# You may override this *but* make sure you adjust the clean.sh accordingly
export ORDERER_FILELEDGER_LOCATION=$HOME/ledgers/orderer/multi-bank/ledger

FABRIC_LOGGING_SPEC=debug

export FABRIC_CFG_PATH=$PWD

# Launch orderer
orderer