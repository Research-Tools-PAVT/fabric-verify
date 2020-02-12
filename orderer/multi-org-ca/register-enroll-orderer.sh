# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# PS: Since Register (step 1) can happen only once - ignore register error if you run multiple times

# Function checks for the availability of the 
function    checkCopyYAML {
    SETUP_CONFIG_CLIENT_YAML="../../setup/config/multi-org-ca/yaml.0/identities/orderer/fabric-ca-client-config.yaml"
    if [ -f "$FABRIC_CA_CLIENT_HOME/fabric-ca-client.yaml" ]
    then 
        echo "Using the existing Client Yaml for orderer"
    else
        echo "Copied the Client Yaml from $SETUP_CONFIG_CLIENT_YAML/orderer "
        mkdir -p $FABRIC_CA_CLIENT_HOME
        cp  "$SETUP_CONFIG_CLIENT_YAML" "$FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml"
    fi
}

# Function sets the FABRIC_CA_CLIENT_HOME
function    setFabricCaClientHome {
    CA_CLIENT_FOLDER="../../ca/multi-org-ca/client/orderer"
    export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
}

# Identity of the orderer will be created by the admin from the orderer org
IDENTITY="admin"
# A function similar to the setclient.sh script - sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Step-1  Register the orderer identity
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer 
echo "======Completed: Step 1 : Registered orderer (can be done only once)===="

# Step-2 Copy the client config yaml file

# Set the FABRIC_CA_CLIENT_HOME for orderer
IDENTITY="orderer"
setFabricCaClientHome

checkCopyYAML
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="

# Step-3 Orderer identity is enrolled
# Admin will  enroll the orderer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
fabric-ca-client enroll -u http://orderer:pw@localhost:7054
echo "======Completed: Step 3 : Enrolled orderer ========"

# Step-4 Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "======Completed: Step 4 : MSP setup for the orderer========"





