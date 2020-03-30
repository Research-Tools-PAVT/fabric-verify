## First Command needs to be --isInit . It has already been done by the scripts executed before.
## We use majority rule so endoersing by two peers are enough

## For Org1 CLI
docker exec -it cli bash

## For Org3 CLI
docker exec -it Org3cli bash

## Invoke Examples
peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["create_bank","ICICI","mbank"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["create_bank","HSBC","fbank"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["create_bank","HDFC","fbank"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["add_forex_currency","ICICI","USD","75.66","100000"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["add_forex_currency","NYCB","USD","75.66","562000"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["transfer_money","ICICI","NYCB","10023","USD", "USD"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["query_balance","ICICI","USD"]}'

peer chaincode invoke -o orderer.payzchain.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/payzchain.com/orderers/orderer.payzchain.com/msp/tlscacerts/tlsca.payzchain.com-cert.pem -C payzchannel -n payzcc --peerAddresses peer0.org1.payzchain.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.payzchain.com/peers/peer0.org1.payzchain.com/tls/ca.crt --peerAddresses peer0.org2.payzchain.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.payzchain.com/peers/peer0.org2.payzchain.com/tls/ca.crt -c '{"Args":["query_balance","NYCB","USD"]}'

## Query Chaincode. These are failing as of now. 
peer chaincode query -n payzcc -C payzchannel -c '{"Args":["list_fbanks"]}'
peer chaincode query -n payzcc -C payzchannel -c '{"Args":["show_bank_details"]}'

## Check Docker logs
docker logs $(docker ps -a | grep dev-peer0.org1 | awk '{print $1}')
