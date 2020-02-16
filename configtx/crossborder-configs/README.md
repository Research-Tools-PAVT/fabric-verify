# Generate the crypto material
- Copy the setup/config/simple-two-org/crypto.1/crypto-config.yaml  to cryptogen/simple-two-org
- cd configtx/simple-two-org
- cryptogen generate --config=../../cryptogen/simple-two-org/crypto-config.yaml

# Generate the genesis
export FABRIC_CFG_PATH=$PWD
configtxgen -profile AcmeOrdererGenesis -channelID ordererchannel -outputBlock acme-genesis.block
configtxgen -inspectBlock ./acme-genesis.block

# Generate the channel tx
configtxgen -outputCreateChannelTx ./acme-channel.tx  -profile AcmeChannel -channelID acmechannel

# Generate the anchor peer update tx
configtxgen -outputAnchorPeersUpdate ./Org1Anchors.tx -profile AcmeChannel -channelID acmechannel -asOrg Org1