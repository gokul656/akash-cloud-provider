curl -sfL https://get.k3s.io | sh - 

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chown $(whoami) $KUBECONFIG

kubectl get pods --all-namespaces