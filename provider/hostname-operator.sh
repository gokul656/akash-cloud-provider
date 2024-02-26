#! /bin/bash

cd ~

export AKASH_KEY_NAME=provider-wallet

provider-services keys export $AKASH_KEY_NAME

if ! command -v "helm" &> /dev/null
then
    wget https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz
    tar -zxvf helm-v3.11.0-linux-amd64.tar.gz
    sudo install linux-amd64/helm /usr/local/bin/helm
else
    echo "Helm already installed $(helm version) so skipping"
fi

# Remove any potential prior repo instances
helm repo remove akash
helm repo add akash https://akash-network.github.io/helm-charts
helm install akash-hostname-operator akash/akash-hostname-operator -n akash-services

# helm uninstall akash-hostname-operator -n akash-services
# kubectl logs akash-hostname-operator-6795445db-vrgs4 -n akash-services
# kubectl delete pods akash-hostname-operator-6795445db-vrgs4 -n akash-services