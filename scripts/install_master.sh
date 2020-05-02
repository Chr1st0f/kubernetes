#!/bin/bash

## install master for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "##########################################################"
echo "## START - install master - "$IP

echo "##########################################################"
echo "## Setup FW ports for master node"
service="firewalld"
systemctl enable $service
systemctl start $service

for port in 6443 2379 2380 10250 10251 10252 10255
 do 
	firewall-cmd --permanent --add-port=${port}/tcp
done
firewall-cmd --reload
firewall-cmd --list-all

echo "##########################################################"
echo "## Sysctl iptables setup"
FILE="/etc/sysctl.d/master_node_name.conf"
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> $FILE
echo "net.bridge.bridge-nf-call-iptables = 1" >> $FILE
sysctl --system

echo "##########################################################"
echo "## Set SElinux in permissive mode"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo "##########################################################"
echo "## Reset cluster if exist"
# Clean setup if there is an existent cluster
kubeadm reset -f

echo "##########################################################"
echo "## Configure Kubernetes master control-plane"
# Creation of cluster
#kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --pod-network-cidr=10.244.0.0/16
kubeadm init --apiserver-advertise-address=$IP --token="$TOKEN" --pod-network-cidr=10.244.0.0/16
echo "##########################################################"
echo "## Copy config file for root"
# Notice : To do fore each user want to use kubernetes
mkdir -p $HOME/.kube
cp -p /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "[3]: create flannel pods network"
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

echo "END - install master - " $IP
