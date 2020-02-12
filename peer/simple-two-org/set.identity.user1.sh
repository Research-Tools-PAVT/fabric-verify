# The env.sh file sets the identity to Peer
# This will set the identity to Admin 

export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/users/User1@acme.com/msp
#export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/ordererOrganizations/acme.com/users/Admin@acme.com/msp
echo ' Switched identity to User1 !!!'
