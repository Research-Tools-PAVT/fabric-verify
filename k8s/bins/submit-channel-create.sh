#!/bin/bash
peer channel create -c airlinechannel -f ../config/airlinechannel.tx --outputBlock ../config/airlinechannel.block -o $ORDERER_ADDRESS
