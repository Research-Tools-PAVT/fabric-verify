# Uses the configtx in this folder
# 1. Generates the cryptogen using the crypto-config in cryptogen/simple-two-org folder
#    Create the ./crypto folder
# 2. Generates the genesis
# 3. Generates the channel

# 1.
cryptogen generate --config=../../cryptogen/simple-two-org/crypto-config.yaml

# 2. 
export FABRIC_CFG_PATH=$PWD
configtxgen -profile AcmeOrdererGenesis -channelID ordererchannel -outputBlock acme-genesis.block

# 3. 
configtxgen -outputCreateChannelTx ./acme-channel.tx  -profile AcmeChannel -channelID acmechannel
