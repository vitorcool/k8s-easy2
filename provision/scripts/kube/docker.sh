#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

echo "------------------------------------------- Installing Kubeadm and Docker"
apt-get install kubeadm -y

### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install apt-transport-https ca-certificates curl software-properties-common -y

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

## Install Docker CE.
if [ -z ${VM_DOCKER_VER} ]; then
  apt-get update && apt-get install docker-ce -y
else
  apt-get update && apt-get install docker-ce=${VM_DOCKER_VER} -y  --allow-downgrades
fi
#apt-get install docker-ce-cli docker-compose -y

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker
read -p "Pause Time 5 seconds" -t 5


#todo - add -H tcp://${CLUSTER_NODE_IP}:4243 to /var/systemd/system/docker.service
# daemon_args=${VM_DOCKER_DAEMON_ARGS}
function replace_docker_daemon_args {
  daemon_args=$(echo $1)

  S_FILE="/lib/systemd/system/docker.service"
  backup_file_or_restore $S_FILE

  S_SEARCH=$(cat $S_FILE | grep  ^ExecStart=)
  S_CMD=$(cat $S_FILE | awk "/ExecStart=/"'{print $1}')
  S_REPLACE="${S_CMD} ${daemon_args}"
  sed -i "s|$S_SEARCH|$S_REPLACE|" $S_FILE
  #echo "file:$S_FILE"
  #echo "search:$S_SEARCH"
  #echo "cmd:$S_CMD"
  #echo "ardgs:$daemon_args"
  cowsay "Docker daemon_args $(cat $S_FILE | grep  ^ExecStart=)"
}
replace_docker_daemon_args "${VM_DOCKER_DAEMON_ARGS}"

# Restart docker.
systemctl daemon-reload
systemctl restart docker
