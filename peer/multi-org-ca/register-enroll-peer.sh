# Creates/Enrolls the Peer's identity + Sets up MSP for peer
# Script needs to be executed for the peers setup
# PS: Since Register (step 1) can happen only once - ignore register error if you run script multiple times

function usage {
    echo "./register-enroll-peer.sh ORG_NAME  PEER_NAME"
    echo "     Sets up the Peer identity and MSP"
    echo "     Script will fail if CA Server is not running!!!"
}

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!!!"
    exit 0
else
    PEER_NAME=$2
fi

# Function checks for the availability of the 
function    checkCopyYAML {
    SETUP_CONFIG_CLIENT_YAML="../../setup/config/multi-org-ca/yaml.0/identities/$ORG_NAME/$PEER_NAME/fabric-ca-client-config.yaml"
    # Placeholder
    # This is not implemented - but is placed here to show how you can manage the CSR for the peers like other identities
}

# Function sets the FABRIC_CA_CLIENT_HOME
function    setFabricCaClientHome {
    CA_CLIENT_FOLDER="../../ca/multi-org-ca/client/$ORG_NAME"
    export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
}

# Identity of the peer will be created by the admin from the organization
IDENTITY="admin"

# A function similar to the setclient.sh script - sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Step-1  Register the identity
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
fabric-ca-client register --id.type peer --id.name $PEER_NAME --id.secret pw --id.affiliation $ORG_NAME 
echo "======Completed: Step 1 : Registered peer (can be done only once)===="

# Set the FABRIC_CA_CLIENT_HOME for peer
IDENTITY=$PEER_NAME
setFabricCaClientHome

# Step-2 Copies the YAML file for CSR setup
checkCopyYAML

# Step-3 Peer identity is enrolled
# Admin will  enroll the peer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
fabric-ca-client enroll -u http://$PEER_NAME:pw@localhost:7054
echo "======Completed: Step 3 : Enrolled $PEER_NAME ========"

# Step-4 Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "======Completed: Step 4 : MSP setup for the peer========"





