# Fabric-verify
Formal Verification of Hyperledger Fabric Chaincode. 

## Vagrant 
```
$ vagrant up
$ vagrant ssh
```
## Chaincode Tests
```
$ cd /vagrant/gopath/src/cross-payment
$ go test
```

## Chaincodes 

Folder : ```./gopath/src/cross-payment```

## CouchDB

```
$ docker run  -e COUCHDB_USER=user -e COUCHDB_PASSWORD=password --name=couchdb -p 5984:5984 -d couchdb:2.2.0
$ docker start couchdb
```


## Docker 
```
$ docker push prodrelworks/fabric-deploy:tagname
```