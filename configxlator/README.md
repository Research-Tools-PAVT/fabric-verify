Command for transforming between the protobuf and JSON
http://hyperledger-fabric.readthedocs.io/en/release-1.1/commands/configtxlator.html


#1 Fetch the config block

peer channel fetch config -o localhost:7050 -c acmechannel
This fetches the acmechannel_config.block

#2 Decode the block
configtxlator proto_decode --input acmechannel_config.block --type=common.Block --output=acmechannel_config.json

#3 Extract the configuration i.e., remove the headers/metadata/signature
jq .data.data[0].payload.data.config acmechannel_config.json > config_original.json

#4 Make copy of the config_original.json to config_updated.json

#5 Make a change to the config_updated.json
Replace localhost:7050 with 127.0.0.1:7050

#6 Encode the blocks
configtxlator proto_encode --input config_original.json --output config_original.block --type common.Config
configtxlator proto_encode --input config_updated.json --output config_updated.block --type common.Config

#7 Compute the updates
configtxlator compute_update --channel_id acmechannel  --original config_original.block --updated config_updated.block --output config_update_compute.block

The block need to be warpped with the proto buffer envelopebefore it can be signed and submitted
Package into a config transaction

#8 Convert to JSON
configtxlator proto_decode --input config_update_compute.block --type common.ConfigUpdate --output=config_update_compute.json
Checkout the content of this JSON it just has the difference between orginal and updated

#9  Wrap with proto buffer envelope

echo '{"payload":{"header":{"channel_header":{"channel_id":"'acmechannel'", "type":2}},"data":{"config_update":'$(cat config_update_compute.json)'}}}' | jq . > config_update_in_envelope.json

jq . formats the output nicely

#10 Now convert the JSON to proto buf

configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.block



Types
=====
common.Block    

common.Config
common.Envelope
common.ConfigUpdate

Update Network
==============
https://hyperledger-fabric.readthedocs.io/en/release-1.1/upgrading_your_network_tutorial.html?highlight=configtxlator

