# Uses the configtx in this folder
# 1. Generates the cryptogen using the crypto-config in cryptogen/simple-two-org folder
#    Create the ./crypto folder
# 2. Generates the genesis
# 3. Generates the channel

# 2. 
export FABRIC_CFG_PATH=$PWD
configtxgen -profile RbiOrdererGenesis -channelID ordererchannel -outputBlock crossborder-genesis.block

# 3. 
configtxgen -outputCreateChannelTx ./crossborder-channel.tx -profile InPaymentChannel -channelID inpaymentchannel

# 4. 
configtxgen -outputAnchorPeersUpdate org1-anchor-in.tx -profile InPaymentChannel -asOrg Org1
configtxgen -outputAnchorPeersUpdate org5-anchor-in.tx -profile InPaymentChannel -asOrg Org5

# 5.
configtxgen -printOrg Org1 > jsonConfig/Org1.json
configtxgen -printOrg Org2 > jsonConfig/Org2.json
configtxgen -inspectBlock crossborder-genesis.block > jsonConfig/genesisBlock.json
configtxgen -inspectChannelCreateTx crossborder-channel.tx > jsonConfig/InPaymentChannel.json
configtxgen -inspectChannelCreateTx org1-anchor-in.tx> jsonConfig/org1Anchor.json
configtxgen -inspectChannelCreateTx org5-anchor-in.tx> jsonConfig/org5Anchor.json