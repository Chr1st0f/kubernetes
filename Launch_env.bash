#!/bin/bash

# Role : This script start a kubernetes cluster 
#        1 - Start the master 
#        2 - Wait a time 
#        3 - Start the 2 worker nodes 

# to connect : 	vagrant ssh kmaster 
#				vagrant ssh knode1 
#				vagrant ssh knode2 


COMMAND="vagrant up "
echo "Build kubernetes cluster : $COMMAND"
$COMMAND

echo "To manage : vagrant ssh kmaster "
echo "            sudo -i "
echo "            kubectl get nodes"
