# Policy at ORG level
Updated with a policy that allows any member of the Org1 to make changes to the config

# Testing
1. Clean up the orderer by executing script in orderer/simple-two-org
   > clean.sh all
2. Copy configtx.yaml to orderer/simple-two-org
3. Initialize the orderer & launch it. Ignore the warnings
   > init.sh
   > orderer

4. In a different terminal switch to folder peer/simple-two-org
5. Clean up the peer by executing script in peer/simple-two-org
   > clean.sh all
6. Setup the environment
   > .  env.sh
7. Overwrite the CORE_PEER_MSPCONFIGPATH to user1 credentials - so in effect we will try to create the channel as an Org1.member instead of Org1.admin
   > export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/users/User1@acme.com/msp
8. Execute the command for creating the channel
   >  peer channel create -o localhost:7050 -c acmechannel -f $CONFIG_DIRECTORY/acme-channel.tx

   << The channel will get created >>

# Optional exercise
1. Open the configtx.yaml
2. Change the Admin Rule for Org1 such that << Rule: "OR('OrdererMSP.admin')" >>
3. Try out this change with the steps above - this time the channel creation will fail