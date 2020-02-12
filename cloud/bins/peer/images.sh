TAG=x86_64-1.2.0
for IMAGE in orderer couchdb peer ca tools
do
  docker pull hyperledger/fabric-${IMAGE}:${TAG} && \
  docker tag hyperledger/fabric-${IMAGE}:${TAG} hyperledger/fabric-${IMAGE}:latest
done