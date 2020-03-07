# Removes the specified identity
# Takes the org name and "enrollment-id" 
# Use this script if you want to play with identity creation/removal
function usage {
    echo    "Usage:    .   ./remove-identity.sh   ORG-Name   Enrollment-ID"
    echo    "Requires:     Server to be started with remove identities enabled"

    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
}

if [ -z $1 ];
then
    usage
    echo   "To REMOVE identity please ORG-Name & enrollment ID"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 0
else
    ENROLLMENT_ID=$2
fi

echo    "Script Requires:  Server MUST be started with remove identities enabled  ./server.sh  enable-remove  !!"

# Remove the identity
# 1 - Only admin can remove the identity, so set client home to admin
source setclient.sh $ORG_NAME admin
# 2 - Now remove 
fabric-ca-client identity remove $ENROLLMENT_ID

# Remove the client folder
source setclient.sh $ORG_NAME $ENROLLMENT_ID
rm -rf $FABRIC_CA_CLIENT_HOME

echo "Done."