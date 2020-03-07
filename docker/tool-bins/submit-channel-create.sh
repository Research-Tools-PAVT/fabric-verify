#!/bin/bash
peer channel create -c airlinechannel -f /var/hyperledger/config/airlinechannel.tx --outputBlock /var/hyperledger/config/airlinechannel.block -o $ORDERER_ADDRESS
