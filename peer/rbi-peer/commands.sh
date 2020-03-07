. ./env.sh
peer channel join -o localhost:7050  -b ./crossborder-genesis.block
peer chaincode package -n crosspaymentcc -v 6.0 -p cross-payment ../chaincode-bin/crosspayment.out 
peer chaincode install ../chaincode-bin/crosspayment.out
peer chaincode instantiate -n crosspaymentcc -v 1.0 -C crosspaymentchannel -c '{"Args":[""]}'
peer chaincode upgrade -C crosspaymentchannel -n crosspaymentcc -v 7.0 -c '{"Args":[""]}'
peer chaincode invoke -n crosspaymentcc -C crosspaymentchannel -c '{"Args":["add_forex_currency", "84", "54", "op", "oolk"]}'

peer chaincode list --installed
peer chaincode list --instantiated -C crosspaymentchannel