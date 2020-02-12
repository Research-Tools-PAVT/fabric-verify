# Initialize the orderer | generate genesis block for ordererchannel

BASE_CONFIG_DIR=../../setup/config/multi-org

# v1.4 change
# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$PWD

#1. Remove files
echo   '=======Deleting artifacts from file system ====='
rm *.tx &> /dev/null
rm *.block &> /dev/null
rmdir -rf ./temp  &> /dev/null
rm -rf /home/vagrant/ledgers/orderer/multi-org/ledger  &> /dev/null

#2. Setup cryptogen for 
echo    '================ Generating crypto-config ================'
rm -rf ./crypto-config 2> /dev/null
cryptogen generate --config=$BASE_CONFIG_DIR/crypto-config.yaml

configtxgen -profile AirlineOrdererGenesis -outputBlock ./airline-genesis.block -channelID ordererchannel

#3. Create the airline channel transaction
echo    '================ Writing acmechannel ================'
configtxgen -profile AirlineChannel -outputCreateChannelTx ./airline-channel.tx -channelID airlinechannel

#4. Create the anchor peer update transactions
ANCHOR_UPDATE_TX=./airline-anchor-update-acme.tx
configtxgen -profile AirlineChannel -outputAnchorPeersUpdate $ANCHOR_UPDATE_TX -channelID airlinechannel -asOrg Acme

ANCHOR_UPDATE_TX=./airline-anchor-update-budget.tx
configtxgen -profile AirlineChannel -outputAnchorPeersUpdate $ANCHOR_UPDATE_TX -channelID airlinechannel -asOrg Budget


echo    '======= Done. Launch by executing orderer ======'
