NOTE:
=====
OPTIONAL - Steps described here are optional as the images are available in Docker Hub
https://hub.docker.com/u/acloudfan
Images used in this project starts with "k8s-"

Configuration elements
======================
Docker images will need configuration for the components:
- Crypto material
- Genesis file
- Channel create tx file
- Anchor update tx file

Fabric YAML files:
- configtx.yaml
- crypto-config.yaml
- orderer/orderer.yaml
- acme/core.yaml
- budget/core.yaml

To generate the config objects & crypto
=======================================
1. Launch the Project VM
2. Log into the VM
3. Change folder to k8s
4. Execute ./init-setup.sh

Reset the environment
=====================
To delete the pods and the PVC, execute the below:
> cd minikube
> reset-env.bat      <<In case of windows>>
> ./reset-env.sh     <<In case of Ubuntu/Mac>>