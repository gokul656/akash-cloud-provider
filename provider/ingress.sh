#! /bin/bash

cd ~

cat > ingress-nginx-custom.yaml << EOF
controller:
  service:
    type: ClusterIP
  ingressClassResource:
    name: "akash-ingress-class"
  kind: DaemonSet
  hostPort:
    enabled: true
  admissionWebhooks:
    port: 7443
  config:
    allow-snippet-annotations: false
    compute-full-forwarded-for: true
    proxy-buffer-size: "16k"
  metrics:
    enabled: true
  extraArgs:
    enable-ssl-passthrough: true
tcp:
  "8443": "akash-services/akash-provider:8443"
EOF

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --version 4.9.1 \
  --namespace ingress-nginx --create-namespace \
  -f ingress-nginx-custom.yaml

kubectl label ns ingress-nginx app.kubernetes.io/name=ingress-nginx app.kubernetes.io/instance=ingress-nginx
kubectl label ingressclass akash-ingress-class akash.network=true

sudo ufw allow 8443
sudo ufw allow 80
sudo ufw allow 443

curl -ks https://localhost:8443/status