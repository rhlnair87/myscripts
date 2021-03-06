#!/bin/bash
MASTER_IP="master01"
WORKER_IPs=(worker01 worker02)
INSTALLER_SCRIPT="kubeadm-installer.sh"
MASTER_CONFIG_SCRIPT="kubeadm-master.sh"
USER=ubuntu

echo -e "copying installer to $MASTER_IP"
scp $INSTALLER_SCRIPT $USER@$MASTER_IP:.
for i in ${WORKER_IPs[@]}; do
	echo -e "copying installer to $i"
	scp $INSTALLER_SCRIPT $USER@$i:.
done

echo -e "Installing on $MASTER_IP"
ssh $USER@$MASTER_IP "bash $INSTALLER_SCRIPT"

for i in ${WORKER_IPs[@]}; do
  echo -e "Installing on $i"
  ssh $USER@$i "bash $INSTALLER_SCRIPT" 
done

echo -e "Configuring master"

ssh $USER@$MASTER_IP "sudo swapoff -a;sudo kubeadm init --pod-network-cidr=10.96.0.0/24"
ssh $USER@$MASTER_IP "mkdir -p ~/.kube;sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config;sudo chown $(id -u):$(id -g) ~/.kube/config;kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

CMD=$(ssh $USER@$MASTER_IP "sudo kubeadm token create --print-join-command")

echo -e "Master should be ready"


echo -e "Joining slaves to master"

for i in ${WORKER_IPs[@]}; do
  echo -e "Joining $i"
  ssh $USER@$i "sudo $CMD"
done

scp dashboard-rbac.yml ingress.sh cidrPatch.sh $USER@$MASTER_IP:.
echo -e "Applying dashboard"
ssh $USER@$MASTER_IP "kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml; kubectl create -f dashboard-rbac.yml"
#ssh $USER@$MASTER_IP "kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml; kubectl create -f dashboard-rbac.yml;kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard-admin | awk '{print $1}')"

echo -e "Use the kubernetes dashboard URL https://$MASTER_IP:6443/ui"

echo -e "Applying trafiek ingress"

ssh $USER@$MASTER_IP "bash cidrPatch.sh;bash ingress.sh"
