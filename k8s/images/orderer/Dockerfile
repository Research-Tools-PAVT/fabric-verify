#Docker file for setting up the acme peer
FROM hyperledger/fabric-orderer:1.4.2

LABEL  maintainer="Sumit Lahiri <lahiri.prodrelworks@gmail.com>"

#1. Create a folder
RUN mkdir -p /var/hyperledger/config

## Install go and other dependencies. 
RUN apt-get update
RUN apt-get install -y curl git sudo
RUN curl -O https://dl.google.com/go/go1.12.14.linux-amd64.tar.gz
RUN tar -xvf go1.12.14.linux-amd64.tar.gz -C /usr/local
RUN rm go1.12.14.linux-amd64.tar.gz

## Set ENV Variables. 
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/var/hyperledger/gochaincode/gopath
ENV PATH=$PATH:/usr/local/go/bin:$GOROOT:$GOPATH

#2. Create the folder for configurations
RUN mkdir -p /var/hyperledger/config

#3. Copy the crypto for orderer
COPY ./config/crypto-config/ordererOrganizations/acme.com/orderers/orderer.acme.com /var/hyperledger/orderer.acme.com

#4. Copy the genesis file
COPY ./config/orderer/airlinegenesis.block  /var/hyperledger/config

#5. Copy the orderer YAML
COPY ./config/orderer/orderer.yaml /var/hyperledger/config

#6. Launch the Orderer
CMD orderer

