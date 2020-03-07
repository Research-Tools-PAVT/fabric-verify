# This utility scripts adds the msp under the organization

function usage {
    echo    "Usage:    setup-org-msp.sh    <ORG-Name>"
    echo    "          Creates the admincerts folder and copies the admin's cert to admincerts folder"
}

if [ -z $1 ]
then
    echo "Please provide ORG-Name!!!"
    usage
    exit 0
else 
    ORG_NAME=$1
fi

# Set the destination as ORG folder
source setclient.sh $ORG_NAME  admin

# Path to the CA certificate
ROOT_CA_CERTIFICATE=./server/ca-cert.pem

# Parent folder for the MSP folder
DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."

# Create the MSP subfolders
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore

# Copy the Root CA Cert
cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts

# Copy the admin certs - ORG admin is the admin for the specified Org
cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts         

echo "Created MSP Under: $DESTINATION_CLIENT_HOME"



