# Utility for adding admincerts to new identity

function usage {
    echo    "Usage:    add-admincerts.sh    <ORG-Name>  <Enrollment-ID>"
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

if [ -z $2 ]
then
    echo "Please provide Enrollment-ID !!!"
    usage
    exit 0
else 
    ENROLLMENT_ID=$2
fi

# Create the destination cliet home folder path
source setclient.sh $ORG_NAME  $ENROLLMENT_ID
DESTINATION_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Set the client home folder to admin's client home folder
source setclient.sh $ORG_NAME  admin

# Create the msp/admincerts folder if its not there
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts

# Copy admin's signcerts to specified identity's admincerts
cp  $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts



