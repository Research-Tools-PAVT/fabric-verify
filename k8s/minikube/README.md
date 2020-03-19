Launching
=========
> kubectl apply -f .

Acme Peer Setup
===============
Log into the acme peer:
> kubectl exec -it acme-peer-0 /bin/bash

Setup the peer:
> ./submit-channel-create.sh
> ./join-channel.sh
> ./anchor-update.sh

Validate the peer:
> ./cc-test.sh install
> ./cc-test.sh instantiate
> ./cc-test.sh invoke  
> ./cc-test.sh query