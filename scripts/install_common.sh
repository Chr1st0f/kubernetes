#!/bin/bash

## install common for k8s

echo "##########################################################"
echo "## Setup common tasks "

echo "LANG=en_US.utf-8" >> /etc/environment
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')

# FILE="/etc/sysctl.d/master_node_name"
# echo "net.bridge.bridge-nf-call-ip6tables = 1" >> $FILE
# echo "net.bridge.bridge-nf-call-iptables = 1" >> $FILE
# sysctl --system

# echo "##########################################################"
# echo "## Deactivate selinux"
# setenforce 0

echo "##########################################################"
echo "## Setup /etc/hosts for $IP"

host_exist=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$host_exist" == "0" ];then
	hostnamectl set-hostname $HOSTNAME 
	file="/etc/hosts" ; field="$HOSTNAME"
	sed -i.bak -r "s/(.+$field.+)/#\1/" $file
	echo "$IP $HOSTNAME " >> /etc/hosts
fi

echo "##########################################################"
echo "## Disable swap"
# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
file="/etc/fstab" ; field="swap"
sed -i.bak -r "s/(.+$field.+)/#\1/" $file

echo "## Update repodb"
#yum -y update >/dev/null
yum check-update

echo "##########################################################"
echo "## Yum install necessary packages"
yum install -y yum-utils device-mapper-persistent-data lvm2 curl bind-utils nmap

echo "## Add docker repository and installation "
if [ ! -f "/usr/bin/docker" ]
 then
 	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
 	yum install -y docker
 	service="docker"
 	systemctl enable $service
 	systemctl start $service
fi


echo "##########################################################"
echo "## Yum install kubernetes packages"
FILE="/etc/yum.repos.d/kubernetes.repo"
if [ ! -f $FILE ]
 then
 	cat <<EOF > $FILE
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

	yum install -y kubelet kubeadm kubectl
	service="kubelet"
	systemctl enable $service
	systemctl start $service
fi

echo "##########################################################"
echo "## END of common install" $IP
