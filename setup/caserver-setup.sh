#!/bin/bash
export PATH=$PATH:$GOROOT/bin

# Sets up the fabric-ca-server & fabric-ca-client
echo "=====Installing libtool library"
sudo apt install -y libtool libltdl-dev


echo "=====Getting fabric ca "
# Document process leads to errors as it leads to pulling of master branch
go get -u github.com/hyperledger/fabric-ca/cmd/...

# git clone --branch release-1.3 https://github.com/hyperledger/fabric-ca.git
# rm -rf $GOPATH/src/github.com/hyperledger/fabric-ca 2> /dev/null
# mv fabric-ca  $GOPATH/src/github.com/hyperledger
# go install github.com/hyperledger/fabric-ca/cmd/...

echo "=====Copying fabric ca binaries"
sudo cp $GOPATH/bin/*    /usr/local/bin

sudo cp $GOPATH/bin/*    $PWD/../bin

sudo rm $GOPATH/bin/* 

echo "Done."


