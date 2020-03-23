cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$PWD
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel 
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP

docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
docker volume prune

export BYFN_CA1_PRIVATE_KEY=priv_sk
export BYFN_CA2_PRIVATE_KEY=priv_sk
export BYFN_CA3_PRIVATE_KEY=priv_sk

docker-compose -f docker-compose-cli.yaml -f docker-compose-etcdraft2.yaml -f docker-compose-couch.yaml -f docker-compose-ca.yaml up -d