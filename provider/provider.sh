export ACCOUNT_ADDRESS="$(provider-services keys show provider-wallet -a)"
export KEY_PASSWORD=gokul656
export DOMAIN=gokulcodes.xyz
export NODE=https://rpc.sandbox-01.aksh.pw:443

echo $ACCOUNT_ADDRESS $KEY_PASSWORD $DOMAIN $NODE

helm repo update

cd ~

rm -rf provider
mkdir provider

cd provider

cat > provider.yaml << EOF
---
from: "$ACCOUNT_ADDRESS"
key: "$(cat ~/key.pem | openssl base64 -A)"
keysecret: "$(echo $KEY_PASSWORD | openssl base64 -A)"
domain: "$DOMAIN"
node: "$NODE"
withdrawalperiod: 12h
chainid: sandbox-01
attributes:
  - key: region
    value: "us-central"
  - key: host
    value: akash
  - key: tier
    value: community
  - key: organization
    value: "akash test provider updated"
  - key: capabilities/gpu/vendor/nvidia/model/t4
    value: true
  - key: capabilities/storage/1/class
    value: beta2   
  - key: capabilities/storage/1/persistent
    value: true
EOF

kubectl apply -f https://raw.githubusercontent.com/akash-network/provider/v0.4.8/pkg/apis/akash.network/crd.yaml

helm install akash-provider akash/provider -n akash-services -f provider.yaml

sleep 5

kubectl -n akash-services logs -l app=akash-provider --tail 200 -f -c init
kubectl -n akash-services logs -l app=akash-provider --tail 200 -f

# kubectl get pods -n akash-services
# helm uninstall akash-provider -n akash-services
# kubectl logs akash-provider-0 -n akash-services --follow