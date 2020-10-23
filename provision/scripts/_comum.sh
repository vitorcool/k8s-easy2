#
# k8sEasy2
#
if [ "${IGNORE_PROVISION}" == "true" ];then
  echo "IGNORE_PROVISION=$IGNORE_PROVISION"
  exit 1
fi

dd=/home/vagrant
# load cluster setup variables if they exist
envFile="$dd/provision/.env.$HOSTNAME"
if [ -z $CLUSTER_NODE_NAME ]; then
  echo "Loading Cluster setup variable into shell enviroment file:$envFile"
  if [ \ $envFile ];then
    . $envFile #loaded
    cowsay " $envFile Loaded OK"
  else
    cowsay " $envFile Load FAIL"
  fi
fi

####################################
function save_bash_environment {
  if [ ! -z $CLUSTER_NODE_NAME ]; then
    cat > $envFile <<EOF
PATH=${dd}/provision/tools:\${PATH}
IGNORE_PROVISION='${IGNORE_PROVISION}'
CLUSTER_NODE_IDX='${CLUSTER_NODE_IDX}'
CLUSTER_NODE_NAME='${CLUSTER_NODE_NAME}'
CLUSTER_NODE_IP='${CLUSTER_NODE_IP}'
CLUSTER_IP_PREFIX='${CLUSTER_IP_PREFIX}'
CLUSTER_NODE_IP_LESS_START='${CLUSTER_NODE_IP_LESS_START}'
CLUSTER_LOADBALANCER_IP_RANGE='${CLUSTER_LOADBALANCER_IP_RANGE}'
CLUSTER_INSTANCES='${CLUSTER_INSTANCES}'
NODE_NAME_PREFIX='${NODE_NAME_PREFIX}'
VM_DNS_RESOLVER='${VM_DNS_RESOLVER}'
VM_SSH_ACCESS_KEY='${VM_SSH_ACCESS_KEY}'
VM_DOCKER_DAEMON_ARGS='${VM_DOCKER_DAEMON_ARGS}'
VM_DOCKER_VER='${VM_DOCKER_VER}'
VM_OS='${VM_OS}'
VM_MEMORY='${VM_MEMORY}'
VM_CPUS='${VM_CPUS}'
VM_SYNC_FOLDERS='${VM_SYNC_FOLDERS}'
EOF

    cowsay " $file Created"
  else
    echo "Enable do save Cluster .env file. CLUSTER_NODE_NAME=|Missing|."
  fi
}

function node_info {
  echo "--------------------------------------------------------------------------"
  echo "IGNORE_PROVISION: ${IGNORE_PROVISION}"
  echo "CLUSTER_NODE_IP: ${CLUSTER_NODE_IP}"
  echo "CLUSTER_NODE_IDX: ${CLUSTER_NODE_IDX}"
  echo "CLUSTER_NODE_NAME: ${CLUSTER_NODE_NAME}"
  echo "CLUSTER_LOADBALANCER_IP_RANGE: ${CLUSTER_LOADBALANCER_IP_RANGE}"
  echo "USER: $(whoami)"
  echo "DIRECTORY: $(pwd)"
}

function backup_file_or_restore {
  $f=$1
  if [ ! -f $f.backup ]; then
    cp $f $f.backup
  else
    cp $f.backup $f
  fi

}
