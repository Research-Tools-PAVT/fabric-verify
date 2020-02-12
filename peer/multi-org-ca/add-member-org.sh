# Adds a new member org configuration to the updated config file (cfg_block_no_envelope_mod.json)
# Before executing this script:
#   1. Identity for the new ORG has been created
#   2. Execute the ./fetch-config-json.sh script
#   3. Setup the configtx.yaml file in ./config folder   
#      [e.g., refer to setup/config/multi-or-ca/yaml.1 in which Budget org is added]

# CHANGE THESE BASED ON NEEDS
CHANNEL_ID="airlinechannel"
NEW_ORG_NAME="Budget"

ORIGINAL_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope.json"
MOD_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope_mod.json"
ORG_JSON="./config/$NEW_ORG_NAME.json"


# 1. Generate the Organization 
export FABRIC_CFG_PATH=$PWD/config 
configtxgen -channelID $CHANNEL_ID -printOrg $NEW_ORG_NAME > "./config/$NEW_ORG_NAME.json"

# 2. Add the Budget Org to the (cfg_block_no_envelope_mod.json)
#    Overwrites the file cfg_block_no_envelope_mod.json

STAR_CHARACTER="*"
JQ_FILTER='.[0]'$STAR_CHARACTER' {"channel_group":{"groups":{"Application":{"groups": {"'$NEW_ORG_NAME'":.[1]}}}}}'
CMD="jq -s '$JQ_FILTER' $ORIGINAL_CFG_NO_ENVELOPE_JSON $ORG_JSON  > $MOD_CFG_NO_ENVELOPE_JSON"

echo "=====> Executing the command ===="
# Echo the command to be executed
echo $CMD
# Execute the command
eval $CMD
echo "================================="

echo "Done. Please check for errors"
echo "VALIDATION: Check if $NEW_ORG_NAME added to $MOD_CFG_NO_ENVELOPE_JSON"

