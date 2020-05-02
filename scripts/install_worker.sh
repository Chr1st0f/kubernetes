#!/bin/bash

## install nodes for k8s

TOKEN="abcdef.0123456789abcdef"
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')

echo "##########################################################"
echo "## Setup FW ports for master node"
service="firewalld"
systemctl enable $service
systemctl start $service

for port in 10251 10255
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
echo "## Reset cluster if exist"
# Clean setup if there is an existent cluster
kubeadm reset -f

echo "##########################################################"
echo "## Join to the cluster"
kubeadm join --ignore-preflight-errors=all --token="$TOKEN" 192.168.100.10:6443 --discovery-token-unsafe-skip-ca-verification

echo "[2]: restart and enable kubelet"
systemctl enable kubelet
service kubelet restart

echo "END - install master - " $IP


