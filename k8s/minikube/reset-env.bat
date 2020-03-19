echo off
REM Resets the minikube Hyperledger setup

REM Delete all generated po | services | statefulset
kubectl delete -f .

REM Delete the PVC explicitly as they do not get deleted by default
kubectl delete pvc --all
