dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

echo "------------------------------------------------- Configuring Master node"
echo "USER: $(whoami)"
echo "DIRECTORY: $(pwd)"
echo "CLUSTER_NODE_IP: $CLUSTER_NODE_IP"
echo "-------------------------------------------------------------------------"

kubeadm init --apiserver-advertise-address=$CLUSTER_NODE_IP --pod-network-cidr=10.244.0.0/16 | tee $dd/k8s-install.log
echo "Error $?"

  cmd_join=$(cat $dd/k8s-install.log | grep "kubeadm join")
  echo "cmd_join=$cmd_join"
  if [ -z $cmp_join ]; then
    echo "$cmd_join" > $dd/provision/cluster-join.sh
    echo " --discovery-token-unsafe-skip-ca-verification" >> $dd/provision/cluster-join.sh
  else
    cowsay "Ops - Kubeadm init <K8S> kubeadm reset it first"
  fi
  mkdir -p $dd/.kube
  cp -u /etc/kubernetes/admin.conf $dd/.kube/config
  chown vagrant:vagrant $dd/.kube/config



cat $dd/.kube/config
