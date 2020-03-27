docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune
docker rmi $(docker images | grep dev-peer0 | awk '{print $3}')
docker rmi $(docker images | grep dev-peer1 | awk '{print $3}')
sleep 5s

./byfn.sh generate -c payzchannel -s couchdb -a
sudo ./byfn.sh up -c payzchannel -s couchdb -a
sleep 10s

./eyfn.sh generate -c payzchannel -s couchdb
sudo ./eyfn.sh up -c payzchannel -s couchdb
sleep 10s

## To Launch the explorer. 
sudo docker-compose -f docker-compose-explorer.yaml up -d
