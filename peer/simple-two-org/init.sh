# Initializes the setup
# Init.sh all overrwites the core

# Initializes the node
WAIT_TIME=5s
ORDERER_ADDRESS="localhost:7050"

#1.  Kill the peer process if it is running
killall peer

#2 Sets up the environment
. env.sh


#3 Cleanup the peer
echo   '1. Clean up all executed'
if [ "$1" == "all" ]; then
    ./clean.sh   all
else 
    ./clean.sh
fi

#4 Check if orderer is up
if pgrep -x "orderer" > /dev/null
then
    echo "2. Orderer is running."
else
    echo "2. Please launch the Orderer & run init again"
    exit 1
fi

#5 Create the channel
echo   '3. Creating the channel: acmechannel - may fail if already created'
peer channel create -o $ORDERER_ADDRESS -c acmechannel -f $CONFIG_DIRECTORY/acme-channel.tx

# If channel already created then -  use the following to fetch channel genesis
#peer channel fetch 0 -o localhost:7050  -c acmechannel  acmechannel.block

#6 Launch the peer in background
peer node start  &

#7 Wait for the peer to launch
echo   '4. Sleeping for WAIT_TIME'
sleep   $WAIT_TIME

#8 Join the channel
echo   '5. Joining channel'
peer channel join -o $ORDERER_ADDRESS -b ./acmechannel.block


#9 Check if the join was successful
echo   '6. Listing channel'
peer channel list

#10 Kill the peer
echo   '7. Kill the peer process'
killall peer

echo "All Steps Executed."
echo "Launch Peer using ./start-node.sh"