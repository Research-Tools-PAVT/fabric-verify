# Enabling the TLS
# Recipe :  Eabling TLS for Peer

# MUST Execute   . env.sh before this file
# Change the VM Hostname & etc/hosts as described in Recipe

export CORE_PEER_LISTENADDRESS=devpeer:7051
export CORE_PEER_ADDRESS=devpeer:7051

export  CORE_PEER_TLS_ENABLED=true
export  CORE_PEER_TLS_KEY_FILE=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/peers/devpeer/tls/server.key
export  CORE_PEER_TLS_CERT_FILE=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/peers/devpeer/tls/server.crt
export  CORE_PEER_TLS_ROOTCERT_FILE=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/acme.com/peers/devpeer/tls/ca.crt