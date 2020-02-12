# Create the airline channel
# Orderer Address env variable is getting set in the set-env.sh

# The transaction file was copied over in Part 2
export CHANNEL_TX_FILE=./airline-channel.tx

# Execute the channel create command
peer channel create -o $ORDERER_ADDRESS -c airlinechannel -f $CHANNEL_TX_FILE