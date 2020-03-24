## Removing existing docker images. Clean docker setup.
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune

# Generating new certificates. Removing the old ones.
rm -rf channel-artifacts crypto-config
cryptogen generate --config=./crypto-config.yaml

## Channel and config generation.
export FABRIC_CFG_PATH=$PWD
export CHANNEL_NAME=mychannel

configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP

## Booting up the network.
docker-compose -f docker-compose-ca.yaml -f docker-compose-cli.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml up -d

## Check if all services running
docker ps -a
docker start $(docker ps -aq)  

## For executing chaincode and peer commands (On three terminals)
docker exec -it cli bash
# docker exec -it Org1Cli bash
# docker exec -it Org2Cli bash
# docker exec -it Org3Cli bash

#####################################################################################################################################################################################################################

## Set ENV for PEER0 on Org1.
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/users/Admin@org1.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org1.payzchain.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

## Set ENV for PEER0 on Org2
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/users/Admin@org2.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org2.payzchain.com:9051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

## Set ENV for PEER0 on Org3.
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/users/Admin@org3.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org3.payzchain.com:11051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

## PEER0 ORG1 CREATE CHANNEL && JOIN CHANNEL
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/users/Admin@org1.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org1.payzchain.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

echo $CHANNEL_NAME
peer channel create -o orderer.payzchain.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

peer channel join -b mychannel.block
peer channel list 

## Update Anchor Peer, for PEER0 ORG1
peer channel update -o orderer.payzchain.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

echo $CORE_PEER_LOCALMSPID

## PEER0 ORG2 JOIN CHANNEL
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/users/Admin@org2.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org2.payzchain.com:9051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

peer channel join -b mychannel.block
peer channel list 

## Update Anchor Peer, for PEER0 ORG2
peer channel update -o orderer.payzchain.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

echo $CORE_PEER_LOCALMSPID

## PEER0 ORG3 JOIN CHANNEL
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/users/Admin@org3.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org3.payzchain.com:11051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

peer channel join -b mychannel.block
peer channel list 

## Update Anchor Peer, for PEER0 ORG3
peer channel update -o orderer.payzchain.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org3MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

echo $CORE_PEER_LOCALMSPID

## Install & Define Chaincode
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/users/Admin@org1.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org1.payzchain.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel

## GO Vendor dependencies. 
cd /opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/marbles02/go
GO111MODULE=on go mod vendor
cd -

# packages and installs the Golang chaincode
peer lifecycle chaincode package marbles.tar.gz --path github.com/hyperledger/fabric-samples/chaincode/marbles02/go/ --lang golang --label marbles_1
peer lifecycle chaincode install marbles.tar.gz

## Verify and store chaincode package ID. 
peer lifecycle chaincode queryinstalled 

## Install chaincode on the Org2
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/users/Admin@org2.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org2.payzchain.com:9051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel
peer lifecycle chaincode install marbles.tar.gz
peer lifecycle chaincode queryinstalled

## Install chaincode on the Org3
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/users/Admin@org3.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org3.payzchain.com:11051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel
peer lifecycle chaincode install marbles.tar.gz
peer lifecycle chaincode queryinstalled

## Approving chaincode for Org1. 
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/users/Admin@org1.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org1.payzchain.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel
peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name marbles --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

## Approving chaincode for Org2.
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/users/Admin@org2.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org2.payzchain.com:9051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel
peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name marbles --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

## Approving chaincode for Org3.
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/users/Admin@org3.payzchain.com/msp
export CORE_PEER_ADDRESS=peer0.org3.payzchain.com:11051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt
export CHANNEL_NAME=mychannel
peer lifecycle chaincode approveformyorg --channelID $CHANNEL_NAME --name marbles --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem

## Checking for commit readinees of the chaincode on to payzchain. We basically check how many organizatiions have approved the chaincode install and commit transactions.  
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name marbles --version 1.0 --init-required --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem --output json

## Approve commit to channel. 
peer lifecycle chaincode commit -o orderer.payzchain.com:7050 --channelID $CHANNEL_NAME --name marbles --version 1.0 --sequence 1 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt --waitForEvent

peer lifecycle chaincode querycommitted

## Invoking the chaincode after the commit is done. 
peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble1","blue","35","tom"]}' --waitForEvent

## Peer chaincode query. 
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["readMarble","marble1"]}'

## Testing Invoke functions: 
peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble2","red","50","tom"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble3","blue","70","tom"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c  '{"Args":["transferMarble","marble2","jerry"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c  '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C $CHANNEL_NAME -n marbles --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt --peerAddresses peer0.org3.payzchain.com:11051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.payzchain.com/peers/peer0.org3.payzchain.com/tls/ca.crt -c  '{"Args":["delete","marble1"]}'

## Issue a range query.
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["getHistoryForMarble","marble1"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["getMarblesByRange","marble1","marble3"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["queryMarblesByOwner","tom"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["queryMarbles","{\"selector\":{\"owner\":\"tom\"}}"]}'
peer chaincode query -C $CHANNEL_NAME -n marbles -c '{"Args":["queryMarblesWithPagination","{\"selector\":{\"owner\":\"tom\"}}","3",""]}'
