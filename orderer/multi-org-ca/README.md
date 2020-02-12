Ensure the Crypto is setup using Fabric-CA
==========================================
cd ca/multi-org-ca
./run-all.sh    
This will setup the Admins & Org MSP 

Orderer Setup
=============
./clean.sh all         cleanup
./init.sh all          initialize the network config

./register-enroll-orderer.sh        Generates an identity for the orderer
The MSP will be created under the folder ca/multi-org-ca/client/orderer/orderer
Re-running this command may throw error as the orderer identity can be registered once

./launch.sh
Make sure there is no error by checking the logs/orderer.log


