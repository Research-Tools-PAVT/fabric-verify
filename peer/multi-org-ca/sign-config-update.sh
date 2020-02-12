# Signs the update config PB file  ./config/cfg_update_block_with_envelope.pb
# E.g.,   ./sign-config-update.sh   acme       Signs the file with acme admin certificate/key
# E.g.,   ./sign-config-update.sh   budget     Signs the file with budget admin certificate/key
function usage {
    echo "./sign-config-update.sh   ORG_NAME"
    echo "                     MUST have executed:"
    echo "                          fetch-config-json.sh"
    echo "                          generate-config-update.sh"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# Path to the update config PB
CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB="./config/cfg_update_block_with_envelope.pb"

# Set the environment variable $1 = ORG_NAME 
source set-identity.sh

# Execute command to sign the tx file in place
peer channel signconfigtx -f $CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB

echo "====> Done. Signed file with identity $ORG_NAME/admin"
echo "====> VALIDATION: Check size & timestamp of file $CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB"