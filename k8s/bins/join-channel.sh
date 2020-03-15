#!/bin/bash
#After running this script confirm that peer has joined
#by running peer channel list
peer channel join   -b ../config/airlinechannel.block -o $ORDERER_ADDRESS

