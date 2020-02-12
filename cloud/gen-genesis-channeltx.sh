# Script for the generation of the 
# genesis block & create channel tx files
# Both files written under the artefacts subfolder

#1 Make sure the orgs-msp.tar is available
tar xvf ./artefacts/orgs-msp.tar -C ./temp

#2 Generate the Genesis block
export FABRIC_CFG_PATH=$PWD
GENESIS_FILE=./artefacts/airline-genesis.block
CHANNEL_NAME=ordererchannel
echo "====> Generating Genesis"
configtxgen -profile AirlineOrdererGenesis -channelID $CHANNEL_NAME -outputBlock $GENESIS_FILE

#3 Generate the airline channel transaction file
CHANNEL_TX_FILE=./artefacts/airline-channel.tx
CHANNEL_NAME=airlinechannel
echo "====> Generating Channel Tx"
configtxgen -profile AirlineChannel -outputCreateChannelTx $CHANNEL_TX_FILE -channelID $CHANNEL_NAME

rm -rf ./temp/*
