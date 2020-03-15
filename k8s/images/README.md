Notes:
======
Kubernetes require the applications to be provided in Docker images

The Docker images are pulled by the K8s runtime from the Registry
- Registry can be local in Minikube VM
- OR it can be a remote registry

When developing the images it is easier to use local Registry as it would
save you the "push" step. Instructions below shows how to use the minikube
registry during development.

You may skip the steps #3 & #4 below if you would like to create the images
in the local/HOST registry. To test you would need to push the image to the 
DockerHub Registry so that minikube can pull it.


Creating the Docker images (OPTIONAL)
=====================================
1. Setup Docker on your HOST machine
2. Setup minikube on your HOST machine 
3. Setup the shell environment variable to point to minikube Registry
4. Run the Docker build command for creating the images in local registry
   * Carry out local testing in minikube
5. Push the images to Docker Hub (or your private repository)
6. Launch the cluster & Deploy K8s/HLF setup

1. Setup Docker on your HOST machine
====================================
Only the client need to be used for creating the Docker images
Please follow the instructions for your HOST to set it up

https://docs.docker.com/v17.12/install/

2. Setup minikube on your HOST machine
======================================
- Install minikube
https://kubernetes.io/docs/tasks/tools/install-minikube/

- Launch minikube
> minikube start

3. Using the minikube VM Docker Registry
========================================
Images will be built directly in the minikube registry
- Get the information about the Docker for minikube
> minikube docker-env

- Setup the shell for executing docker build commands
On Windows use GitBash | Cygwin
Set up the environment - copy values or variables from the earlier step
 >  set DOCKER_TLS_VERIFY="1"
 >  set DOCKER_HOST="tcp://192.168.99.101:2376"
 >  set DOCKER_CERT_PATH="C:\Users\Rajeev\.minikube\certs"


4. Building the images
======================
# Delete all images - MAKE sure previous steps are followed otherwise
# this will delete the Docker images from your HOST machines :)
docker rmi $(docker images -a -q) -f

# These commands to be executed in the k8s folder
> docker build -t acloudfan/k8s-hlf-acme-orderer:1.0 . -f images/orderer/Dockerfile
> docker build -t acloudfan/k8s-hlf-acme-peer:1.0 . -f images/acme-peer/Dockerfile
> docker build -t acloudfan/k8s-hlf-budget-peer:1.0 . -f images/budget-peer/Dockerfile

5. Push the images to image registry
====================================
This step is needed for making the image available to others from the Registry
For production a private registry will be used

For testing this step may be skipped as the image is already pushed to 
minikube registry

Following will push the images to Docker Hub
> docker login -u <<Docker Hub User ID>>

** Replace acloudfan with your id **
> docker push acloudfan/k8s-hlf-acme-orderer:1.0
> docker push acloudfan/k8s-hlf-acme-peer:1.0
> docker push acloudfan/k8s-hlf-budget-peer:1.0



6. Launch the cluster
=====================
** Replace the reference to images **
kubectl apply -f .\k8s-orderer.yaml
kubectl replace --force -f .\k8s-acme-orderer.yaml
kubectl replace --force -f .\k8s-acme-peer.yaml
kubectl replace --force -f .\k8s-budget-peer.yaml

PVC does not get deleted by default :)
> kubectl get pvc
> kubectl delete pvc --all


Cheatsheet
https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index

https://github.com/alejandrolr/fabric-on-kubernetes/blob/master/scripts/artifacts/configtx.yaml