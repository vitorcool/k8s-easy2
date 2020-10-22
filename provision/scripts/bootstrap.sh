#
# k8sEasy2S
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh
node_info

echo "------------------------------------------------------- Installing cowsay"
apt-get update | apt-get install cowsay -y
cp /usr/games/cowsay /usr/bin

echo "----------------------------------------------- store .env.$HOSTNAME file"
# create .env.$HOSTNAME file
save_bash_environment
node_info

echo "------------------------------------------------------------- Disable swap"
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab

echo "---------------------------------------------------Install SSH Custom keys"
cat ${VM_SSH_ACCESS_KEY} >> /home/vagrant/.ssh/authorized_keys
systemctl restart sshd

echo "-------------------------------------------------------- Update hosts file"
f="/etc/hosts"
backup_file_or_restore $f
n="${CLUSTER_INSTANCES}"
ipls="${CLUSTER_NODE_IP_LESS_START}"
for ((i = 1 ; i <= n; i++)); do
  hostNAME="${NODE_NAME_PREFIX}$i"
  node_ip_less=$(expr $ipls + $i - 1)
  hostIP="${CLUSTER_IP_PREFIX}.$node_ip_less"
  echo "$hostIP $hostNAME" >> /etc/hosts
done
cowsay $(cat /etc/hosts)

echo "------------------------------------------------------ Update DNS Resolver to: ${VM_DNS_RESOLVER}"
echo "nameserver ${VM_DNS_RESOLVER}">/etc/resolv.conf
cowsay $(cat /etc/resolv.conf)

apt-get update
