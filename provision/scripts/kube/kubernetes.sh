#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

node_info

echo "---------------------------- Adding required apt keys and Kubernetes repos"
wget -qO- https://packages.cloud.google.com/apt/doc/apt-key.gpg > $dd/apt-key.gpg
apt-key add $dd/apt-key.gpg
echo "apt_preserve_sources_list: true" >> /etc/cloud/cloud.cfg

apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update


# Enable packet forwarding
sysctl net.bridge.bridge-nf-call-iptables=1
