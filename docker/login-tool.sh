#!/bin/bash

# You may use either docker or docker-compose to execute commands

#docker-compose -f config/docker-compose-base.yaml exec tools /bin/bash

docker-compose exec -it tools /bin/bash
