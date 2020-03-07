#!/bin/sh
# Resets the minikube Hyperledger setup


# Delete all generated po | services | statefulset
kubectl delete -f .

# Delete the PVC explicitly as they do not get deleted by default
kubectl delete pvc --all
