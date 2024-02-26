#! /bin/bash

cd ~/
git clone https://github.com/kubernetes-sigs/kubespray.git --depth 1

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y

sudo apt install python3.9 -y
sudo apt install python3-pip virtualenv -y
sudo apt install python3.9-distutils -y

cd ~/kubespray
virtualenv --python=python3.9 venv

source ./venv/bin/activate
pip3 install -r requirements.txt

cp -rfp inventory/sample inventory/akash
declare -a IPS=(10.0.0.10) # FIXME: fetch from API
CONFIG_FILE=inventory/akash/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sed -i 's/^#upstream_dns_servers/upstream_dns_servers/g' inventory/akash/group_vars/all/all.yml
sed -i 's/^#\(- [0-9.]\+\)/\1/g' inventory/akash/group_vars/all/all.yml

ansible-playbook -i inventory/akash/hosts.yaml -b -v --private-key=~/.ssh/id_rsa cluster.yml

kubectl get nodes