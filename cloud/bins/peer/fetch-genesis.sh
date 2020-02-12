# Fetches the genesis for the specified channel
CHANNEL_NAME=ordererchannel

peer channel fetch 0 -c $CHANNEL_NAME -o $ORDERER_ADDRESS