
Intro to Kubernetes
===================
https://dzone.com/articles/10-basic-facts-about-kubernetes-that-you-didnt-kno

+---------------------------------------------+
PS: +  These are notest/observations
    +  Follow the videos for minikube install
+---------------------------------------------+


Locally launch minikub (Not Suggested)
======================================
install it 
https://medium.com/@nieldw/running-minikube-with-vm-driver-none-47de91eab84c

Changed the memory to 4GB & CPU=2
minikube start   <<< Gave error - required changing the permission >>>
sudo chown -R $USER $HOME/.kube $HOME/.minikube
minikube start  <<< Failed to update cluster: downloading binaries: copying kubelet: copy: error removing file /usr/
bin/kubelet: remove /usr/bin/kubelet: permission denied>>>

sudo minikube start

sudo /usr/bin/kubeadm init --config /var/lib/kubeadm.yaml  --ignore-preflight-errors=...,--data-minikube,FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml,FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml,FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml,FileAvailable--etc-kubernetes-manifests-etcd.yaml,Port-10250,Swap


Build the Docker Images
=======================
docker build -t acloudfan/hyperledger-orderer:1.0 .


Install Kubectl
===============
sudo snap install kubectl --classic

Install minikube
================
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

sudo install minikube /usr/local/bin