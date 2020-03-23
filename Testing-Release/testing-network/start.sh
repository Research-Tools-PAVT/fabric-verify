## Removing existing docker images. Clean docker setup.
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune


# Generating new certificates. Removing the old ones.
rm -rf channel-artifacts crypto-config
cryptogen generate --config=./crypto-config.yaml

## Channel and config generation.
export FABRIC_CFG_PATH=$PWD
export CHANNEL_NAME=payzchain
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP

## Booting up the network.
docker-compose -f docker-compose-cli.yaml -f docker-compose-etcdraft2.yaml -f docker-compose-couch.yaml -f docker-compose-ca.yaml up -d

## Check if all services running
docker ps -a

