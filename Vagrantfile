IGNORE_PROVISION = false
CLUSTER_IP_PREFIX = "192.168.3"
CLUSTER_NODE_IP_LESS_START = 200  # master will have 192.168.3.200, node1 .201, node2 .202 ips
CLUSTER_LOADBALANCER_IP_RANGE = "#{CLUSTER_IP_PREFIX}.100-#{CLUSTER_IP_PREFIX}.199"
CLUSTER_INSTANCES = 3 # HA only available when > 3 [knode1,knode2,knode3]
NODE_NAME_PREFIX = "kdev"
VM_DNS_RESOLVER = "8.8.8.8"
# file SSH-RSA OpenSSH Format
VM_SSH_ACCESS_KEY ="/home/vagrant/provision/vitor_public_key.pub"
VM_DOCKER_DAEMON_ARGS = "-H fd:// -H tcp://#{CLUSTER_IP_PREFIX}.#{CLUSTER_NODE_IP_LESS_START}:4243"
VM_DOCKER_VER = "18.06.2~ce~3-0~ubuntu"
VM_OS = "ubuntu/xenial64"
VM_MEMORY = 1024 #3072
# K8s requires at least 2 CPUs
VM_CPUS = 2
VM_SYNC_FOLDERS = [
  ["d:/WWW","/www"]
]


def cluster_provision_args()
  {
    "IGNORE_PROVISION" => "#{IGNORE_PROVISION}",
    "CLUSTER_NODE_IDX" => "#{CLUSTER_NODE_IDX}",
    "CLUSTER_NODE_NAME" => "#{CLUSTER_NODE_NAME}",
    "CLUSTER_NODE_IP" => "#{CLUSTER_NODE_IP}",
    "CLUSTER_IP_PREFIX" => "#{CLUSTER_IP_PREFIX}",
    "CLUSTER_NODE_IP_LESS_START" => "#{CLUSTER_NODE_IP_LESS_START}",
    "CLUSTER_LOADBALANCER_IP_RANGE" => "#{CLUSTER_LOADBALANCER_IP_RANGE}",
    "CLUSTER_INSTANCES" => "#{CLUSTER_INSTANCES}",
    "NODE_NAME_PREFIX" => "#{NODE_NAME_PREFIX}",
    "VM_DNS_RESOLVER" => "#{VM_DNS_RESOLVER}",
    "VM_SSH_ACCESS_KEY" => "#{VM_SSH_ACCESS_KEY}",
    "VM_DOCKER_DAEMON_ARGS" => "#{VM_DOCKER_DAEMON_ARGS}",
    "VM_DOCKER_VER" => "#{VM_DOCKER_VER}",
    "VM_OS" => "#{VM_OS}",
    "VM_MEMORY" => "#{VM_MEMORY}",
    "VM_CPUS" => "#{VM_CPUS}",
    "VM_SYNC_FOLDERS" => "#{VM_SYNC_FOLDERS}"
  }
end

Vagrant.configure("2") do |config|

  # Xenial is a bit old but works best at the moment. Kubectl repo seems to bedash
  # Xenial is a bit old but works best at the moment. Kubectl repo seems to be
  # available for Xenial only currently
  config.vm.box = VM_OS
  # Sync time with the local host
  config.vm.provider 'virtualbox' do |vb|
   vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
   vb.memory = VM_MEMORY
   vb.cpus = "#{VM_CPUS}"
  end
  # Change the provision to match your environment
  config.vm.synced_folder "./provision", "/home/vagrant/provision"
  for index in 0 ... VM_SYNC_FOLDERS.size
    folder = VM_SYNC_FOLDERS[index]
    config.vm.synced_folder folder[0], folder[1]
  end

  (1..CLUSTER_INSTANCES).each do |i|
    config.vm.define "#{NODE_NAME_PREFIX}#{i}" do |node|

      name = "#{NODE_NAME_PREFIX}#{i}"
      ip = "#{CLUSTER_IP_PREFIX}.#{i+CLUSTER_NODE_IP_LESS_START-1}"


      node.vm.hostname  = name
      node.vm.network "private_network", ip: ip
      node.vm.provider "virtualbox" do |vb|
        vb.name = name
      end

      CLUSTER_NODE_NAME = name
      CLUSTER_NODE_IP = ip
      CLUSTER_NODE_IDX = i

      node.vm.provision "bootstrap", type: "shell", path: "provision/scripts/bootstrap.sh", env: cluster_provision_args(), run: "runonce"
      node.vm.provision "kube",      type: "shell", path: "provision/scripts/kube.sh",      env: cluster_provision_args(), run: "runonce"
      node.vm.provision "node",      type: "shell", path: "provision/scripts/node.sh",      env: cluster_provision_args()

    end
  end
end
