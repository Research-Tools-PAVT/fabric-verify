#!/bin/bash
if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'setup'"
    echo "Usage: sudo ./caserver.sh"
    exit 0
fi

echo "=======Set up go...PLEASE Wait======"
# sudo apt-get update
# sudo apt-get -y install golang-1.12-go
# mv /usr/lib/go-1.10 /usr/local
# mv /usr/local/go-1.10   /usr/local/go

curl -O https://dl.google.com/go/go1.12.14.linux-amd64.tar.gz
tar -xvf go1.12.14.linux-amd64.tar.gz -C /usr/local
rm go1.12.14.linux-amd64.tar.gz

# If GOROOT already set then DO Not set it again
if [ -z $GOROOT ]
then
    echo "export GOROOT=/usr/local/go" >> ~/.profile
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
    echo "export GOPATH=`pwd`/../gopath" >> ~/.profile
    echo "======== Updated .profile with GOROOT/GOPATH/PATH===="

    echo "export GOROOT=/usr/local/go" >> ~/.bashrc
    echo "export GOPATH=`pwd`/../gopath" >> ~/.bashrc
    echo "======== Updated .profile with GOROOT/GOPATH/PATH===="


else
    echo "======== No Change made to .profile ====="
fi

echo "======= Done. PLEASE LOG OUT & LOG Back In ===="
echo "Then validate by executing    'go version'"