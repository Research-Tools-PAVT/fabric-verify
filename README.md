# Fabric-verify
Formal Verification of Hyperledger Fabric Chaincode. 

## Chaincodes 

Folder : ```./gopath/src/cross-payment```

## CouchDB

```
$ docker run  -e COUCHDB_USER=user -e COUCHDB_PASSWORD=password --name=couchdb -p 5984:5984 -d couchdb:2.2.0
$ docker start couchdb
```
