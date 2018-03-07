#!/bin/bash

set -eou pipefail
IFS=$'\n\t'

apt-get update \
  && apt-get install -qy docker.io
  
apt-get update && apt-get install -y apt-transport-https \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
  
apt-get update \
  && apt-get install -y conntrack kubelet kubeadm kubernetes-cni

