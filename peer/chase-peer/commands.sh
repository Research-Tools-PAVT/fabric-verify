peer chaincode query -n fabcc -C crosspaymentchannel -c '{"Args":["queryAllCars"]}'
peer chaincode query -C crosspaymentchannel -n fabcc -c '{"Args":["queryCar","CAR1"]}'
peer chaincode upgrade -n gocc -v 4.0 -C crosspaymentchannel -c '{"Args":["init","a","950","b","700"]}'
peer chaincode invoke -C crosspaymentchannel -n gocc -c '{"Args":["invoke","b","a","30"]}'

peer chaincode invoke -C crosspaymentchannel -n fabcc -c '{"Args":["initLedger"]}'
