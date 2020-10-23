#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh
node_info

###### MASTER NODE START ######
if [[ ${CLUSTER_NODE_IDX} -eq 1 ]];then
  # run as root user
  runuser -l root -c "$dd/provision/scripts/node/master.sh"
  # run as vagrant User
  runuser -l vagrant -c "$dd/provision/scripts/node/addons.sh"
fi
###### MASTER NODE END ######


###### WORKER NODE START ######
if [[ ${CLUSTER_NODE_IDX} -gt 1 ]];then
  # run as root user
  runuser -l root -c "$dd/provision/scripts/node/slave.sh"
fi
###### WORKER NODE END ######
