#!/bin/bash
# Update /etc/hosts
source    ./manage_hosts.sh

HOSTNAME=peer1.acme.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=peer1.budget.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=orderer.acme.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=postgresql
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=explorer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=vagrant
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME