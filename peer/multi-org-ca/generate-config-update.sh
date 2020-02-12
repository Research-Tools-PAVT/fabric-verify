# Evaluates the Delta
# Expects the following files to be available in the ./cfg folder
#                 cfg_block_no_envelope.json  cfg_block_no_envelope_mod.json

function usage {
    echo "./generate-config-update.sh  CHANNEL_ID  "
    echo "               MUST have executed fetch-config-json.sh"
    echo "               Output:  ./config   cfg_update_block_with_envelope.json"
    echo "                                   cfg_update_block_with_envelope.pb"
}

# Check the channel id
if [ -z $1 ]
then
    usage
    echo 'Please provide CHANNEL_ID!!!'
    exit 1
else 
    CHANNEL_ID=$1
fi


ORIGINAL_CFG_NO_ENVELOPE_PB="./config/cfg_block_no_envelope.pb"
MOD_CFG_NO_ENVELOPE_PB="./config/cfg_block_no_envelope_mod.pb"

ORIGINAL_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope.json"
MOD_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope_mod.json"


CFG_UPDATE_BLOCK_NO_ENVELOPE_PB="./config/cfg_update_block_no_envelope.pb"
CFG_UPDATE_BLOCK_NO_ENVELOPE_JSON="./config/cfg_update_block_no_envelope.json"

CFG_UPDATE_BLOCK_WITH_ENVELOPE_JSON="./config/cfg_update_block_with_envelope.json"
CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB="./config/cfg_update_block_with_envelope.pb"

# 1. Convert original JSON with no envelope to PB
configtxlator proto_encode --input $ORIGINAL_CFG_NO_ENVELOPE_JSON --type common.Config --output $ORIGINAL_CFG_NO_ENVELOPE_PB

# 2. Convert modified JSON with no envelope to PB
configtxlator proto_encode --input $MOD_CFG_NO_ENVELOPE_JSON --type common.Config --output $MOD_CFG_NO_ENVELOPE_PB

# 3. Compute the delta 
configtxlator compute_update --channel_id $CHANNEL_ID --original $ORIGINAL_CFG_NO_ENVELOPE_PB --updated $MOD_CFG_NO_ENVELOPE_PB --output $CFG_UPDATE_BLOCK_NO_ENVELOPE_PB

# 4. Convert the Update block PB to JSON
configtxlator proto_decode --input $CFG_UPDATE_BLOCK_NO_ENVELOPE_PB --type common.ConfigUpdate  > $CFG_UPDATE_BLOCK_NO_ENVELOPE_JSON

# 5. Now wrap the Update config JSON with the envelope
ENVELOPE='{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_ID'", "type":2}},"data":{"config_update":'$(cat $CFG_UPDATE_BLOCK_NO_ENVELOPE_JSON)'}}}'
echo $ENVELOPE | jq . > $CFG_UPDATE_BLOCK_WITH_ENVELOPE_JSON

# 6. Convert the update block from JSON to PB
configtxlator proto_encode --input $CFG_UPDATE_BLOCK_WITH_ENVELOPE_JSON --type common.Envelope --output $CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB

echo "Done. Generated $CFG_UPDATE_BLOCK_WITH_ENVELOPE_PB"
echo "VALIDATION: Open $CFG_UPDATE_BLOCK_WITH_ENVELOPE_JSON and check if modified config included?"