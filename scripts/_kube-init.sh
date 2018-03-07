#!/bin/bash

set -eou pipefail
IFS=$'\n\t'

temp=${1:-}
if [[ -z "$temp" ]]; then
    echo "usage: $0 tempdir"
    exit 1
fi

printf "running kubeadm init..."
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=172.17.8.100 --kubernetes-version stable-1.9 | \
    tee init.out | \
    grep "kubeadm join" | \
    sed -e 's/^\s*//' > /vagrant/$temp/join.sh
printf "finished\n"


sudo sysctl net.bridge.bridge-nf-call-iptables=1 > /dev/null

printf "copying config..."
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo cp /etc/kubernetes/admin.conf /vagrant/.tmp
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" | tee -a ~/.bashrc
printf "finished\n"

printf "applying weave pod network..."
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
printf "finished\n"
