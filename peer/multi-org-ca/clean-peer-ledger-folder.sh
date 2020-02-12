# This script removes the ledger folder for the specified peer
# Prior to running this script please ensure that peer process
# is killed.
function usage {
    echo ". clean-peer-ledger.sh   ORG_NAME   PEER_NAME"
    echo "     Please make sure the peer is NOT running"
}

# Set the environment vars
source set-env.sh

echo "====> Deleting.....$CORE_PEER_FILESYSTEM_PATH"

# Delete the ledger
sudo rm -rf $CORE_PEER_FILESYSTEM_PATH

echo "====> Done."