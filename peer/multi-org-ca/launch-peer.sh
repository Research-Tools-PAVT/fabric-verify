function usage {
    echo ". launch-peer.sh   ORG_NAME   PEER_NAME  [PORT_NUMBER_BASE default=7050] "
    echo "                   Sets the environment variables for the peer & then launches it"
}

# Org name Must be provided
if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

# Peer name Must be provided
if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!!!"
    exit 0
else 
    PEER_NAME=$2
fi

# Set up the environment variables
source set-env.sh
./show-env.sh
export CORE_PEER_FILESYSTEMPATH="/var/ledgers/multi-org-ca/$ORG_NAME/$PEER_NAME/ledger" 

# Create the ledger folders
# To retain the environment vars we need to use -E flag with sudo
sudo -E mkdir -p $CORE_PEER_FILESYSTEMPATH

# Create the folder for the logs
mkdir -p $PEER_LOGS

# Start the peer
sudo -E peer node start 2> $PEER_LOGS/peer.log &

echo "====>PLEASE Check Peer Log under  $PWD/$ORG_NAME/$PEER_NAME"
echo "====>Make sure there are no errors!!!"