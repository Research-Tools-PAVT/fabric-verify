block-json.sh
=============
# Extract Application group
./block-json.sh application 
# Extract Orderer group
./block-json.sh orderer 
# Extract application channel_group
./block-json.sh channel_group
 # Extract Channel policies
./block-json.sh channel_group policies
# Extract Application policies
./block-json.sh  channel_group groups.Application.policies
# Extract Application - ACLs & Policies
./block-json.sh acls



# Common launch error
2019-02-09 15:03:05.535 UTC [orderer.common.server] Main -> ERRO 001 failed to parse config:  Error reading configuration: Unsupported Config Type ""

Happens because v1.4 requires the FABRIC_CFG_PATH to be set, earlier versions falled back to $PWD not v1.4
To address the error:

export FABRIC_CFG_PATH=$PWD
orderer


Multi Org Setup
===============
Org#1   Orderer org - dedicated org for the Orderer service
Org#2   Acme Airlines
Org#3   Budget Airlines

To Setup the Orderer
====================
Execute the ./init.sh
- Cleans the file system
- Generates the crypto materal. Uses setup/config/multi-org/crypto-config.yaml
- Generates the Genesis block and the create channel transaction

#v1.4 orderer fails to launch if the config path variable is NOT set
export FABRIC_CFG_PATH=$PWD
Orderer

You may use the script ./launch.sh

