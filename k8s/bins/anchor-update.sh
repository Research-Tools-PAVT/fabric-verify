#!/bin/bash

peer channel update -f ../config/acme-peer-update.tx -c airlinechannel -o $ORDERER_ADDRESS

