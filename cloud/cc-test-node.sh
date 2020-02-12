# Use this for testing your cloud setup *or* even local setup :)
# Example ./cc-test.sh  install  
function    usage {
    echo  "Usage: ./cc-test-node.sh    install | instantiate | invoke | query "
    echo  "Installs the Node JS CC to specified Organization"
}

# Uses the core.yaml file in current folder - copy of core.yaml under cloud/bins/peer
export FABRIC_CFG_PATH=./

export CC_NAME="nodecc4"
export CC_PATH="../nodechaincode/chaincode_example02"

OPERATION=$1

echo "CC Operation : $OPERATION    for   Org: $CURRENT_ORG_NAME"

# Invoke the "peer chain code" command using the operation
case $OPERATION in
    "install")   
              peer chaincode install  -n $CC_NAME -p $CC_PATH -v $CC_VERSION -l node

              peer chaincode list --installed -C airlinechannel
        ;;
    "instantiate")
              peer chaincode instantiate -C $CC_CHANNEL_ID -n $CC_NAME  -v $CC_VERSION -c $CC_CONSTRUCTOR -l node

              #peer chaincode list --instantiated -C airlinechannel
        ;;
    "query")
            echo -n "query a="
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'
            echo -n "query b="
            peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","b"]}'
        ;;
    
    "invoke")
            echo "Invoke sending 5 token from a=>b"
            peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["invoke","a","b","5"]}'
        ;;

    *) usage
esac



