#!/bin/bash
# Deletes the folders from the project
# BUT does not Uninstall/remove binaries
# Execute this script in setup folder

SETUP_FOLDER=$PWD

rm -rf ../fabric-samples 2> /dev/null
echo "===> fabric-samples deleted ==="

rm -rf ../gopath 2> /dev/null
echo "===> GOPATH folder deleted ==="

rm -rf ../nodechaincode
echo "===> nodechaincode folder deleted ==="


#Clean the cryptogen folders
cd $SETUP_FOLDER/../cryptogen
echo "===> cryptogen"
./clean.sh all

# Clean the configtx
cd $SETUP_FOLDER/../configtx
echo "===> configtx"
./clean.sh all


# Clean up the Peer folders
cd $SETUP_FOLDER/../peer/simple-two-org
echo "===> peer/simple-two-org"
./clean.sh all


cd $SETUP_FOLDER/../peer/multi-org
echo "===> peer/multi-org"
./clean.sh all


cd $SETUP_FOLDER/../peer/multi-org-ca
echo "===> peer/multi-org-ca"
./clean.sh all

# Clean up the Orderer 
cd $SETUP_FOLDER/../orderer/simple-two-org
echo "===> orderer/simple-two-org"
./clean.sh all

cd $SETUP_FOLDER/../orderer/multi-org
echo "===> orderer/multi-org"
./clean.sh all

cd $SETUP_FOLDER/../orderer/multi-org-ca
echo "===> orderer/multi-org-ca"
./clean.sh all

cd $SETUP_FOLDER/../cloud
echo "===> cloud"
./clean.sh all

cd $SETUP_FOLDER/../ca
echo "===> ca"
./clean.sh all

cd $SETUP_FOLDER/../ca/multi-org-ca
echo "===> ca/multi-org-ca"
./clean.sh all

# Delete the bin folder
rm $SETUP_FOLDER/../bin/* 2> /dev/null

# Delete the docker setup
cd $SETUP_FOLDER/../docker
echo "===> docker"
./clean.sh all

# Delete the kubernetes setup
cd $SETUP_FOLDER/../k8s
echo "===> kubernetes(k8s)"
./clean-all.sh 

# Delete the kafka setup
rm -r $SETUP_FOLDER/kafka/bin
rm -r $SETUP_FOLDER/kafka/config
rm -r $SETUP_FOLDER/kafka/libs
rm -r $SETUP_FOLDER/kafka/site-docs
rm $SETUP_FOLDER/kafka/NOTICE
rm $SETUP_FOLDER/kafka/LICENSE



# Clean up the folder .vagrant
echo "==================CLEAN UP Task Done. ================="
echo "To Remove VM. Please run the command   'vagrant destroy' on host machine"
echo "MANUALLY Delete the .vagrant folder!!!"