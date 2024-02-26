#! /bin/bash

kubectl create ns akash-services
kubectl label ns akash-services akash.network/name=akash-services akash.network=true

kubectl create ns lease
kubectl label ns lease akash.network=true

chmod +x ~/scripts/provider/*

source ~/scripts/provider/hostname-operator.sh
source ~/scripts/provider/provider.sh
# ./scripts/provider/ingress.sh

kubectl get pods -n akash-services
kubectl get pods -n ingress-nginx