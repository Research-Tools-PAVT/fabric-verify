#!/bin/bash

############################
# Setup anchor peer for acme
# Set the context
. set-context.sh acme

# Submit the channel create tx
./submit-channel-create.sh

# Give time for the channel tx to propagate
sleep 3s

# Join acme peer to the channel
./join-channel.sh

sleep 3s

# Update anchor peer in channel
./anchor-update.sh

############################
# Setup anchor peer for budget
# Set the context
. set-context.sh budget

# Join the budget peer
./join-channel.sh

sleep 3s

# Update anchor peer in channel
./anchor-update.sh