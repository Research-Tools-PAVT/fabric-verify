echo "===== Cleaning the configtx ======"
rm ./simple-two-org/*.tx  2> /dev/null
rm ./simple-two-org/*.block 2> /dev/null
rm -rf ./simple-two-org/crypto-config 2> /dev/null
rm -rf ./simple-two-org/temp
echo "Done."