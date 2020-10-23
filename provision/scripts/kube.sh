#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh
node_info

# run as root user
runuser -l root -c "$dd/provision/scripts/kube/kubernetes.sh"

# run as root user
runuser -l root -c "$dd/provision/scripts/kube/docker.sh"

# Enable packet forwarding
sysctl net.bridge.bridge-nf-call-iptables=1
