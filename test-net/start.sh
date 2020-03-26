docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune
docker rmi $(docker images | grep dev-peer0 | awk '{print $3}')

./byfn.sh generate -c payzchannel -s couchdb
sudo ./byfn.sh up -c payzchannel -s couchdb
./eyfn.sh generate -c payzchannel -s couchdb
sudo ./eyfn.sh up -c payzchannel -s couchdb
