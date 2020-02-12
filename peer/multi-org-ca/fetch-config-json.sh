# Fetches the latest config block for the specified channel
# You MUST set the environment with some ORG admin's MSP 
# prior to executing this script. Only authorized admins 
# will be able to execute it.

function usage {
    echo "./fetch-config-json.sh  CHANNEL_ID [ORDERER_ADDRESS default=localhost:7050] "
    echo "               MUST set the environment prior to executing this script"
    echo "               E.g., > . set-env.sh  acme peer1 7050 admin"
    echo "               Output:  ./config   cfg_block.pb cfg_block.json  cfg_block_mod.json  "
    echo "                        ./config   cfg_block_no_envelope.json  cfg_block_no_envelope_mod.json"
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

# Check the Orderer Address
if [ -z $2 ]
then
    ORDERER_ADDRESS="localhost:7050"
    echo "=====> Using default orderer localhost:7050"
else 
    ORDERER_ADDRESS=$2
fi

# Remove all of the old files
rm ./config/*.pb    2> /dev/null
rm ./config/*.json  2> /dev/null

# File names
ORIGINAL_PB="./config/cfg_block.pb"
ORIGINAL_CFG_JSON="./config/cfg_block.json"
ORIGINAL_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope.json"
MOD_CFG_NO_ENVELOPE_JSON="./config/cfg_block_no_envelope_mod.json"


# 1. This will fetch the latest config
echo "=====> 1. Fetching:  $ORIGINAL_PB"
peer channel fetch config $ORIGINAL_PB  -c $CHANNEL_ID -o $ORDERER_ADDRESS

# 2. Convert to JSON
echo "=====> 2. Converting:  $ORIGINAL_PB to $ORIGINAL_CFG_JSON"
configtxlator proto_decode --input $ORIGINAL_PB --type common.Block  > $ORIGINAL_CFG_JSON

# 3. Extract the config data i.e., Remove envelope
echo "=====> 3. Removing envelope:  $ORIGINAL_CFG_NO_ENVELOPE_JSON"
cat  $ORIGINAL_CFG_JSON | jq .data.data[0].payload.data.config > $ORIGINAL_CFG_NO_ENVELOPE_JSON

# 4. Creates a file by copying the original
echo "=====> 4. Copying: $ORIGINAL_CFG_NO_ENVELOPE_JSON  to   $MOD_CFG_NO_ENVELOPE_JSON "
cp $ORIGINAL_CFG_NO_ENVELOPE_JSON  $MOD_CFG_NO_ENVELOPE_JSON

echo   "Done.  Make config changes to the following files:"
echo   "       $MOD_CFG_NO_ENVELOPE_JSON"

