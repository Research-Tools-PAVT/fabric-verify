# Used for deleting the peer data & crypto
exit 1

source set-env.sh

echo "Deleting files from $CORE_PEER_FILESYSTEMPATH"

rm -rf $CORE_PEER_FILESYSTEMPATH/*