./clean.sh

export FABRIC_CFG_PATH=$PWD

# Change this to see log meesage details
export ORDERER_GENERAL_LOGLEVEL=DEBUG


#3. Setup cryptogen for peers & orderer
echo    '================ Generating crypto-config ================'
rm -rf ./crypto-config 2> /dev/null
cryptogen generate --config=../config/crypto-config.yaml --output="./crypto-config"

#4. Setup the genesis block
echo    '================ Writing genesis ================'
configtxgen -profile RbiOrdererGenesis -channelID ordererchannel -outputBlock crossborder-genesis.block

#5. Create the In-Bound Channel transactions
echo    '================ Writing In-Bound Specific Channel ================'
configtxgen -outputCreateChannelTx ./insider-channel.tx -profile InPaymentChannel -channelID inpaymentchannel

#5. Create the Out-Bound Cross Border Channel transactions
echo    '================ Writing Cross-Border Channel ================'
configtxgen -outputCreateChannelTx ./crossborder-channel.tx -profile CrossPaymentChannel -channelID crosspaymentchannel
