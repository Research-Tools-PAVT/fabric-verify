# Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID

function usage {
    echo    "Usage:    .   ./setclient.sh   ORG-Name   Enrollment-ID"

    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
}

if [ -z $1 ];
then
    usage
    echo   "To CHANGE please provide ORG-Name & enrollment ID"
    exit 1
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 1
fi

export FABRIC_CA_CLIENT_HOME=`pwd`/client/$1/$2
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

if [ "$0" = "./setclient.sh" ]
then
    echo "Did you use the . before ./setclient.sh? If yes then we are good :)"
fi

