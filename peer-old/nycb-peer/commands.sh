. ./env.sh
peer chaincode install exampleV1.0.out
peer chaincode install fabcarV1.0.out
peer chaincode instantiate -n fabcc -v 1.0 -C crosspaymentchannel -c '{"Args":[""]}'
peer chaincode instantiate -n exmplecc -v 1.0 -C crosspaymentchannel -c '{"Args":["init","a","54000","b","48500"]}'
peer chaincode invoke -n fabcc -C crosspaymentchannel -c '{"Args":["initLedger"]}'
peer chaincode query -n fabcc -C crosspaymentchannel -c '{"Args":["queryAllCars"]}'
peer chaincode query -n exmplecc -C crosspaymentchannel -c '{"Args":["query", "b"]}'
peer chaincode invoke -n exmplecc -C crosspaymentchannel -c '{"Args":["invoke", "b", "a", "700"]}'
peer chaincode query -n exmplecc -C crosspaymentchannel -c '{"Args":["query", "b"]}'
peer chaincode query -n exmplecc -C crosspaymentchannel -c '{"Args":["query", "a"]}'
peer chaincode query -n fabcc -C crosspaymentchannel -c '{"Args":["queryCar", "CAR0"]}'