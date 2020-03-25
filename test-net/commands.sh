## First Command needs to be --isInit . It has already been done by the scripts executed before.
## We use majority rule so endoersing by two peers are enough

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n marblescc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble1","blue","35","tom"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n marblescc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble2","red","50","tom"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n marblescc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["initMarble","marble3","blue","70","tom"]}'

peer chaincode query -C payzchannel -n marblescc -c '{"Args":["getHistoryForMarble","marble1"]}'
peer chaincode query -C payzchannel -n marblescc -c '{"Args":["queryMarbles","{\"selector\":{\"owner\":\"tom\"}}"]}'
peer chaincode query -C payzchannel -n marblescc -c '{"Args":["queryMarblesWithPagination","{\"selector\":{\"owner\":\"tom\"}}","3",""]}'

peer chaincode query -C payzchannel -n marblescc -c '{"Args":["getMarblesByRange","marble1","marble3"]}'


## For Clean Start

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune
docker rmi $(docker images | grep dev-peer0 | awk '{print $3}')

sudo ./byfn.sh generate -c payzchannel -s couchdb
sudo ./byfn.sh up -c payzchannel -s couchdb
sudo ./eyfn.sh generate -c payzchannel -s couchdb
sudo ./eyfn.sh up -c payzchannel -s couchdb

docker exec -it cli bash 
