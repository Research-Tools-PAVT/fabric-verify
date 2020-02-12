Demonstrates the use of Docker for setting Fabric
=================================================


Folders
=======
config                      Contains all the config artefacts
config/crypto-config        Contains the crypto
tool-bins                   Scripts used from within the tools container
bins                        Scripts used on VM terminal prompt

Utility Scripts
===============
./init-setup.sh             Initializes and launches the Fabric setup
./shutdown.sh               Shutsdown the enviornment/containers without losing the peer setup
./clean.sh                  Deletes the volumes so data for peers & orderers is lost
./clean.sh                  Cleans up volumes, crypto & nw artefacts
./login-tool.sh             Log into the running tools container
./clean-volume.sh           Delete specific volume


**************************************
Using Utility Script to Launch Env.
======================================

#1 Initialize the network & launch
./init-setup.sh

#2 Test with acme
. bins/set-context.sh  acme
./bins/cc-test.sh      install
./bins/cc-test.sh      instantiate

./bins/cc-test.sh invoke
./bins/cc-test.sh query

#3 Test with budget
. bins/set-context.sh  budget
./bins/cc-test.sh      install
./bins/cc-test.sh invoke
./bins/cc-test.sh query

************************************************
Manually Setup Environment Using tools container
================================================

Part-1   Setup the network artefacts
====================================

#1 Launch just the tools container & Log into it
docker-compose -f ./config/docker-compose-base.yaml up -d tools  
./login-tool.sh

#2 Generate the crypto matrial
cd /var/hyperledger/config
cryptogen generate --config=/var/hyperledger/config/crypto-config.yaml

#3 Generate the network artefacts

export FABRIC_CFG_PATH=$PWD

configtxgen -outputBlock  ./orderer/airlinegenesis.block -channelID ordererchannel  -profile AirlineOrdererGenesis

configtxgen -outputCreateChannelTx  airlinechannel.tx -channelID airlinechannel  -profile AirlineChannel

#4 Exit out of the tools container
exit
docker-compose -f ./config/docker-compose-base.yaml down

Part-2  Setup the acme & budget peers
=====================================
#1 Launch the environment

docker-compose -f ./config/docker-compose-base.yaml up -d

#2 Log into the tools container

./login-tool.sh

#3 As acme create | join | update channel
. set-context.sh acme
./submit-channel-create.sh
./join-channel.sh
./anchor-update.sh

peer channel list

#4 As Budget join | update channel
. set-context.sh budget
./join-channel.sh
./anchor-update.sh

peer channel list

Part-3  Test the environment
============================

#1 Install & Instantiate the chaincode as acme
. set-context.sh  acme
./cc-test.sh      install
./cc-test.sh      instantiate

#2 Query & Invoke 
./cc-test.sh invoke
./cc-test.sh query

#3 Install & Query as Budget
. set-context.sh  budget
./cc-test.sh      install
./cc-test.sh      query

***********************************************
Manually Setup Environment Using binaries on VM
===============================================

Part-1   Setup the network artefacts
====================================

#1 Generate the crypto matrial
cd config
cryptogen generate --config=crypto-config.yaml

#2  Generate the network artefacts
export FABRIC_CFG_PATH=$PWD

configtxgen -outputBlock  ./orderer/airlinegenesis.block -channelID ordererchannel  -profile AirlineOrdererGenesis

configtxgen -outputCreateChannelTx  airlinechannel.tx -channelID airlinechannel  -profile AirlineChannel

Part-2  Setup the acme & budget peers
=====================================
#1 Launch the environment

docker-compose -f ./config/docker-compose-base.yaml up -d

#2 As acme create | join | update channel
. bins/set-context.sh acme
./bins/submit-channel-create.sh
./bins/join-channel.sh
./bins/anchor-update.sh

peer channel list

#2 As budget join | update channel
. bins/set-context.sh budget
./bins/join-channel.sh
./bins/anchor-update.sh

peer channel list

Part-3  Test the environment
============================

#1 Install & Instantiate the chaincode as acme
. bins/set-context.sh  acme
./bins/cc-test.sh      install
./bins/cc-test.sh      instantiate

#2 Query & Invoke 
./bins/cc-test.sh invoke
./bins/cc-test.sh query

#3 Install & Query as Budget
. ./bins/set-context.sh  budget
./bins/cc-test.sh      install
./bins/cc-test.sh      query


TLS
===
- Orderer setup requires the TLS to be enabled 
- Peer setup requires the TLS to be enabled

Refer to the tls/docker-compose-tls.yaml for the parameters that are updated in config

- launch.sh     Takes a $1=tls for enabling the TLS launch
- bins/set-context.sh  takes $2=tls for setting the TLS parameters in the environment
- bins/init-setup.sh   takes $1=tls for launching the setup with TLS enabled

1. To launch
./init-setup.sh   tls
2. To switch context
.   ./bins/set-context.sh  acme   tls
.   ./bins/set-context.sh  budget   tls
3. To test use ./bins/cc-test.sh
./cc-test.sh install
./cc-test.sh instantiate
./cc-test.sh invoke
./cc-test.sh query