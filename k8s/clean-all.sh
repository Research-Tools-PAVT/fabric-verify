#!/bin/sh

#1. Delete the crypto folder
rm -r ./config/crypto-config

#2. Delete the config TX files
rm ./config/*.tx

#3. Delete the genesis file
rm ./config/orderer/*.block

echo "Done."