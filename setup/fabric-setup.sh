#!/bin/bash
export PATH=$PATH:$GOROOT/bin

echo "GOPATH=$GOPATH"
echo "GOROOT=$GOROOT"

# Execute in the setup folder
echo "=== Must execute in the setup folder ===="

# Updates the /etc/hosts file for native access
./update_etc_hosts.sh

cd ..

echo "====== Starting to Download Fabric ========"
# Documentation or Bootstrap script has an issue
# If -s is placed before the versions (per doc) then you will see a harmless error msg
#curl -sSL http://bit.ly/2ysbOFE | bash  1.3.0 1.3.0 0.4.10 -s

curl -sSL http://bit.ly/2ysbOFE -o bootstrap.sh

chmod 755 ./bootstrap.sh

# Feb 2019 - switched to v1.4
#bash ./bootstrap.sh  1.3.0 1.3.0 0.4.10 
# ./bootstrap.sh  1.4.0 1.4.0 0.4.10 
bash  ./bootstrap.sh  1.4.2 1.4.2 

echo "======= Copying the binaries to /usr/local/bin===="
mkdir -p  bin

cp fabric-samples/bin/*    /usr/local/bin
cp fabric-samples/bin/*    bin
rm -rf fabric-samples/bin



# The sample chaincode is under the subfolder go and need to come under gopath/src subfolder
echo "======= Setting up the GOPATH folder $GOPATH ===="
mkdir -p $GOPATH/src
cp -r fabric-samples/chaincode/*    $GOPATH/src
cp $GOPATH/src/chaincode_example02/go/chaincode_example02.go $GOPATH/src/chaincode_example02   

echo "======= Setting up the Node chaincode folder ==="
mkdir -p $GOPATH/../nodechaincode/chaincode_example02
cp -r fabric-samples/chaincode/chaincode_example02/node/*    $GOPATH/../nodechaincode/chaincode_example02

# This downloads the shim code 
echo "======= Setting up the HLF Shim (Takes time  - Get a Coffee :)===="
# mkdir -p  $GOPATH/src/github.com/hyperledger
# go get -u --tags nopkcs11 github.com/hyperledger/fabric/core/chaincode/shim

# CHANGE 1.4-3.2 - Above replaced with the following
go get -v -u github.com/hyperledger/fabric-chaincode-go/shim

# The sample chaincode is under the subfolder go and need to come under gopath/src subfolder

