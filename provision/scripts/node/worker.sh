dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

echo "------------------------------------------------- Configuring Master node"
echo "USER: $(whoami)"
echo "DIRECTORY: $(pwd)"
echo "-------------------------------------------------------------------------"

# get copy of cluster-join to ~ directory
cp $dd/provision/cluster-join.sh $dd/cluster-join.sh
chmod 755 $dd/cluster-join.sh
$dd/cluster-join.sh
if [ $? -eq 0 ];then
  cowsay "\"$CLUSTER_NODE_NAME\" worker joined to cluster"
else
  cowsay "Ops - \"$CLUSTER_NODE_NAME\" cluster worker node must be already joined with the master. To Kubeadm join <K8S> kubeadm reset it first"
fi
