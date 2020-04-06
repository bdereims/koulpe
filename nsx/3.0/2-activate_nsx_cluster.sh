#!/bin/bash -e
#bdereims@vmware.com

. ./env

function configure_nsx_cluster() {
  #rm ~/.ssh/known_hosts

  local manager_ip=$NSX_MANAGER_IP
  local manager_password=${NSX_MANAGER_PASSWORD:=$NSX_COMMON_PASSWORD}
  local edge_ip=$NSX_EDGE_IP
  local edge_password=${NSX_EDGE_PASSWORD:=$NSX_COMMON_PASSWORD}

  echo "Get NSX manager thumbprint"
  local manager_thumbprint=`eval sshpass -p $manager_password ssh -o StrictHostKeyChecking=no root@$manager_ip "/opt/vmware/nsx-cli/bin/scripts/nsxcli -c \"get certificate api thumbprint\""`

  echo "Set Service Upgrade On"
  sshpass -p $manager_password ssh -o StrictHostKeyChecking=no root@$manager_ip "/opt/vmware/nsx-cli/bin/scripts/nsxcli -c \"set service install-upgrade enable\""

  #echo "Set sending log to vrli"
  #sshpass -p $manager_password ssh -o StrictHostKeyChecking=no root@$manager_ip "/opt/vmware/nsx-cli/bin/scripts/nsxcli -c \"set logging-server ${OVA_VRLI_IP} proto udp level info\""

  for EDGE_IP in ${NSX_EDGE_IP[@]}; do
    echo "---"
    echo "Join NSX edge(s) to management plane"

    eval sshpass -p $edge_password ssh root@${EDGE_IP} -o StrictHostKeyChecking=no "/opt/vmware/nsx-cli/bin/scripts/nsxcli -c \"join management-plane $manager_ip username admin thumbprint $manager_thumbprint password $manager_password\""
    
    eval sshpass -p $edge_password ssh root@${EDGE_IP} -o StrictHostKeyChecking=no "/opt/vmware/nsx-cli/bin/scripts/nsxcli -c \"set logging-server ${OVA_VRLI_IP} proto udp level info\""
  done
}


configure_nsx_cluster
