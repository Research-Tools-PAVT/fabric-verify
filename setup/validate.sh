#!/bin/bash
#Validates the setup to ensure environment is ready to be used.

#1. Validating machine
echo    "------------------ Ubuntu --------------------"
lsb_release -a
echo -n "User:           "  
echo $USER

#2. Validate pre requisites
echo    "-------------- Pre-requisites ------------------"
python   --version
docker   --version
docker-compose    --version
go  version



#3. Validate the fabric
echo    "-------------- Fabric ------------------"
peer version &>  /dev/null
if [ $? != 0 ]; then
    echo  "Fabric    not installed (yet)"
else
    peer version
    orderer version
    echo  "Fabric binaries:"    
    ls   /usr/local/bin
    echo "Docker Images:"
    docker images
fi

fabric-ca-server &> /dev/null
if [ $? != 0 ]; then
    echo  "Fabric CA   not installed (yet)"
else
    echo ""
    fabric-ca-server   version
fi

#4. Validate the fabric
echo    "-------------- Tools ------------------"

node -v  &> /dev/null
if [ $? != 0 ]; then
    echo  "NodeJS    not installed (yet)"
else
    node -v
fi

jq --version &>  /dev/null
if [ $? != 0 ]; then
    echo  "JQ    not installed (yet)"
else
   echo -n "JQ:       "
   jq --version
fi

kubectl version &>  /dev/null
if [ $? != 0 ]; then
    echo  "kubectl    not installed (yet)"
else
   echo -n "kubectl:       "
   kubectl version
fi

minikube version &>  /dev/null
if [ $? != 0 ]; then
    echo  "minikube    not installed (yet)"
else
   echo -n "minikube:       "
   minikube version
fi

#5. Validate the environment
echo    "-------------- Environment ------------------"
echo "GOPATH   $GOPATH"
echo "GOROOT   $GOROOT"
echo "PATH     $PATH"
env  | grep FABRIC_
env  | grep ORDERER_
env  | grep CORE_

#6. Check the hosts
echo    "-------------- Hosts ------------------"
cat /etc/hosts | grep 127.


echo "---------------- Done ---------------------"
echo "To share this report with Raj, use the command  :      ./validate.sh  > validate.txt"
echo "Share the the content of file: validate.txt in your question"