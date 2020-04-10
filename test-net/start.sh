docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune
docker rmi $(docker images | grep dev | awk '{print $3}')
rm -rf org3-artifacts/crypto-config crypto-config connection-org* channel-artifacts
sleep 10s

./byfn.sh generate -c payzchannel -s couchdb -a
./byfn.sh up -c payzchannel -s couchdb -a
sleep 5s

./eyfn.sh generate -c payzchannel -s couchdb
./eyfn.sh up -c payzchannel -s couchdb
sleep 10s

# ## To Launch the explorer.
docker-compose -f docker-compose-explorer.yaml up -d

## Rebuild/Install new chaincode with updates.
# ./dev.sh deploy -q <seq>
