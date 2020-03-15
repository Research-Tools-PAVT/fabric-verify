#Docker file for setting up the acme peer
FROM hyperledger/fabric-peer:1.4.2

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

# shim for hyperledger fabric
RUN go get -v -u github.com/hyperledger/fabric-chaincode-go/shim

#2. Copy the crypto for peer crypto
COPY ./config/crypto-config/peerOrganizations/acme.com/peers/peer1.acme.com /var/hyperledger/peer1.acme.com

#3. Copy the crypto for admin crypto
COPY ./config/crypto-config/peerOrganizations/acme.com/users /var/hyperledger/users

#4. Copy the anchor peer update tx
COPY ./config/acme-peer-update.tx /var/hyperledger/config

#5. Copy the channel create tx file
COPY ./config/airlinechannel.tx  /var/hyperledger/config

#6. Copy the core YAML
COPY ./config/acme/core.yaml /var/hyperledger/config

#7. Copy the bins
COPY ./bins /var/hyperledger/bins

#8. Copy the test chaincode
COPY ./gochaincode  /var/hyperledger/gochaincode

#9. Set the working dir
# RUN  echo "cd /var/hyperledger/bins" >> $HOME/.profile
RUN  echo "cd /var/hyperledger/bins" >> $HOME/.bashrc

#10. Set the context for Admin user
RUN echo ". /var/hyperledger/bins/set-context.sh" >> $HOME/.bashrc

#11. Launch the peer
CMD peer node start
