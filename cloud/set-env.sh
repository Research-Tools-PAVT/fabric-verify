# Make sure that IP Addresses are setup properly
# Use PUBLIC IP Here


export ORDERER_ADDRESS=34.234.63.197:7050

export ACME_EP=54.174.114.12:7051
export BUDGET_EP=34.239.138.203:7051



# Ignore for the time being :)
export EXPO_EP=54.87.106.2:7051

# Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
export CC_NAME="gocc"
export CC_PATH="chaincode_example02"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="airlinechannel"

export CORE_LOGGING_LEVEL=info

function    usage {
    echo  "Usage: . ./set-env.sh    ORG_NAME"
    echo  "Sets the environment for the specific org"
}

export CURRENT_ORG_NAME=$1

echo "Setting environment for $CURRENT_ORG_NAME"

# Set environment variables based on the ORG_Name
case $CURRENT_ORG_NAME in
    "acme")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/acme.com/users/Admin@acme.com/msp
              export CORE_PEER_ADDRESS=$ACME_EP
              export CORE_PEER_LOCALMSPID=AcmeMSP
        ;;
    "budget") export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/budget.com/users/Admin@budget.com/msp
              export CORE_PEER_ADDRESS=$BUDGET_EP
              export CORE_PEER_LOCALMSPID=BudgetMSP
        ;;
    "expo")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/expo.com/users/Admin@expo.com/msp
              export CORE_PEER_ADDRESS=$EXPO_EP
              export CORE_PEER_LOCALMSPID=ExpoMSP
        ;;
    

    *) usage
esac