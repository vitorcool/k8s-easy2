#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

echo "------------------------------------------------- Configuring Master node"
echo "USER: $(whoami)"
echo "DIRECTORY: $(pwd)"
echo "CLUSTER_NODE_IP: $CLUSTER_NODE_IP"
echo "-------------------------------------------------------------------------"


kubeadm init --apiserver-advertise-address=$CLUSTER_NODE_IP --pod-network-cidr=10.244.0.0/16 | tee $dd/k8s-install.log

cmd_join=$(cat $dd/k8s-install.log | grep -A2 "kubeadm join" )
master_inited=$(echo $cmd_join | awk "/kubeadm join/"'{print $2}')

if [ "$master_inited" == "join" ]; then
  cowsay "Cluster initialized and this is the master node"
  echo "$cmd_join" > $dd/provision/cluster-join.sh
  cowsay "Join cluster command \r${cmd_join}"

  mkdir -p $dd/.kube
  cp -u /etc/kubernetes/admin.conf $dd/.kube/config
  chown vagrant:vagrant $dd/.kube/config
else
  cowsay "Ops - This cluster master node must be already initialized. To Kubeadm init <K8S> kubeadm reset it first"
fi
