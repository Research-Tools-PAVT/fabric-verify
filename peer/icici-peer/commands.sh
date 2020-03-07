. ./env.sh
peer channel join -o localhost:7050  -b ./crossborder-genesis.block
peer chaincode package -n crosspaymentcc -v 6.0 -p cross-payment ../chaincode-bin/crosspayment.out 
peer chaincode install ../chaincode-bin/crosspayment.out
peer chaincode instantiate -n crosspaymentcc -v 1.0 -C crosspaymentchannel -c '{"Args":[""]}'
peer chaincode upgrade -C crosspaymentchannel -n crosspaymentcc -v 7.0 -c '{"Args":[""]}'
peer chaincode invoke -n crosspaymentcc -C crosspaymentchannel -c '{"Args":["add_forex_currency", "84", "54", "op", "oolk"]}'

peer channel list
peer chaincode list --installed
peer chaincode list --instantiated -C crosspaymentchannel

peer chaincode package -n samplecc -v 1.0 -p couch-sample ../chaincode-bin/couchsample.out
peer chaincode install ../chaincode-bin/couchsample.out 
peer chaincode instantiate -n samplecc -v 1.0 -C crosspaymentchannel -c '{"Args":[""]}'

peer chaincode invoke -n samplecc -C crosspaymentchannel -c '{"Args":["initMarble","marble3","blue","70","tom"]}'
peer chaincode invoke -n samplecc -C crosspaymentchannel -c '{"Args":["initMarble","marble2","red","50","tom"]}'
peer chaincode invoke -n samplecc -C crosspaymentchannel -c '{"Args":["initMarble","marble1","blue","35","tom"]}'
peer chaincode invoke -n samplecc -C crosspaymentchannel -c '{"Args":["transferMarblesBasedOnColor","blue","jerry"]}'
peer chaincode invoke -n samplecc -C crosspaymentchannel -c '{"Args":["transferMarble","marble2","jerry"]}'

peer chaincode query -n samplecc -C crosspaymentchannel -c '{"Args":["getMarblesByRange","marble1","marble3"]}'

peer chaincode query -n samplecc -C crosspaymentchannel -c '{"Args":["queryMarblesByOwner","tom"]}'
peer chaincode query -n samplecc -C crosspaymentchannel -c '{"Args":["queryMarbles","{\"selector\":{\"owner\":\"tom\"}}"]}'

docker logs dev-rbibank-peer-crosspaymentcc-1.0.0