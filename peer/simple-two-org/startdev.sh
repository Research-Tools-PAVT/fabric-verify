# Launches the peer process

# Set the environment variables for overriding the config in core.yaml

# export CORE_LOGGING_LEVEL=DEBUG
export FABRIC_LOGGING_SPEC=debug

# Launch the peer with Peer's Identity/MSP
export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/peers/devpeer/msp


# Launch the node with dev mode
peer node start -o localhost:7050 --peer-chaincodedev=true 

