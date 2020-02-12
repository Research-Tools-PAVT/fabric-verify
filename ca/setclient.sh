# Sets the home folder for the client
# fabric-ca-client looks for this environment vars 
function usage {
    echo 'To switch the client user folder'
    echo 'Usage:   ./setclientuser.sh  <user  default=admin> '
}

if [ -z "$1" ];
then
    USER="admin"
else
    USER=$1
fi

export FABRIC_CA_CLIENT_HOME=`pwd`/client/$USER
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
