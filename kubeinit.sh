#!/bin/bash

# Initialize Kubernetes master
if [ "$1" == "master" ]; then
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  # Install network plugin (Flannel)
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

  # Generate join command
  kubeadm token create --print-join-command > /vagrant/join_command.sh
fi

# Join Kubernetes worker
if [ "$1" == "worker" ]; then
  sudo $(cat /vagrant/join_command.sh)
fi
