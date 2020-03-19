#!/bin/bash
# Update /etc/hosts
source    ./manage_hosts.sh

HOSTNAME=peer1.acme.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=orderer.rbi.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=rbi.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=icici.com
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
HOSTNAME=hdfc.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=hsbc.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=nycb.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME
HOSTNAME=boa.com
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=rbi-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=icici-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=hdfc-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=hsbc-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=nycb-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME

HOSTNAME=boa-main-peer
removehost $HOSTNAME            &> /dev/null
addhost $HOSTNAME