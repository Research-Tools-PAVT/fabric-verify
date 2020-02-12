# Initialize the environment variables ORDERER_ADDRESS & MSP ID
source ./set-env.sh

# Peer Need to be launched under its own Identity
export CORE_PEER_MSPCONFIGPATH=./msps/peer

peer node start 