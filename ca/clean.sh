
# Cleans up the server & client runs

killall fabric-ca-server  2> /dev/null

rm Issuer*  2> /dev/null
rm -rf msp  2> /dev/null
rm *.db     2> /dev/null
rm ca-cert.pem  2> /dev/null
rm *.yaml  2> /dev/null

if [ "$1" == "all" ];
then 
    rm -rf ./client/*
    rm -rf ./server/*
    exit 0
fi

rm -rf ./client/msp

# Delete files generated in the ca folder (by mistke :)
rm ./server/*.db     2> /dev/null
rm ./server/Issuer*  2> /dev/null
rm ./server/*.pem    2> /dev/null
rm -rf ./server/msp  2> /dev/null


