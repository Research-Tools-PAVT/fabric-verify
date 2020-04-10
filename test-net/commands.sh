## First Command needs to be --isInit . It has already been done by the scripts executed before.
## We use majority rule so endoersing by two peers are enough

## For Org1 CLI
docker exec -it cli bash

## For Org3 CLI
docker exec -it Org3cli bash

## Check Docker logs
docker logs $(docker ps -a | grep dev-peer0.org1 | awk '{print $1}')
