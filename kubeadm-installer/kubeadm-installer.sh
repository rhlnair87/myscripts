#!/bin/bash

sudo apt-get update && apt-get install -y apt-transport-https
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo deb http://apt.kubernetes.io/ kubernetes-xenial main | sudo tee  /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo  apt-get install -y docker.io
sudo apt-get install --allow-unauthenticated -y kubelet kubeadm kubectl kubernetes-cni
sudo ufw disable
#sudo iptables -t nat -A POSTROUTING -s 10.96.0.0/24 -j MASQUERADE
