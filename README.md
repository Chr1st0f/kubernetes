# Creation of kubernetes cluster on centos 

## Rôle : 
  This repo allow you to create a cluster kubernetes on your personnal environment 
  It is composed of a vagrant file and several scripts to build the cluster 

## Details :
 - Vagrantfile : To create your environment with virtualbox 
 - scripts/install_common.sh : Install the common tasks standards packages ( docker , kubernetes , others ) 
 - scripts/install_master.sh : Will install the master part of the cluster 
 - scripts/install_worker.sh : Will install worker part 

## Pre-requisites :
 - Virtualbox 
 - Vagrant 
 - Clone this repo :)

## Installation : 
 ( Has been done on Macos but no worries for other os like windows 10 )

 - Go to the clon directory 
 - To create the environment : vagrant up 
 - To delete the environment : vagrant destroy [ -f ]

 - To connect to master : 	vagrant ssh kmaster 
 							sudo -i
 							kubectl get nodes

##  Explanation : 
 This package will create for you a kubenetes cluster composed of :
  - 1 Master called kmaster 
  - 2 nodes called knode1 and knode2 

 
