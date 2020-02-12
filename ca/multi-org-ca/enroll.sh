# Utility script for identity enrollments

NOT DONE

if [ -z $1 ];
then
    usage
    echo   "Please provide ORG-Name & enrollment ID"
    exit 1
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 1
fi


export FABRIC_CA_CLIENT_HOME=`pwd`/client/$1/$2

