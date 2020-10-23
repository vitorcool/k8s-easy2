# k8s-vagrant
<img src="https://kubernetes.io/images/favicon.png" width="100" height="100" /> <img src="https://hyzxph.media.zestyio.com/Vagrant_VerticalLogo_FullColor.rkvQk0Hax.svg" width="100" height="100" />

## This Vagrant project will start a local kubernetes cluster with:
- 1 master node and 2 slaves
- Kubernetes Dashboard
- fully function Metallb LoadBalancer
- webapp01 deployment YAML

## Requirements
###### *The host computer must have install*
- [git](https://git-scm.com/downloads)
- [vagrant](https://www.vagrantup.com/downloads.html) - This project has been devepoled and tested with Vagrant >=2.2.10 .
- [virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Cluster configurable

### Default configuration
  ```shell
  # disable vagrant provision scripts
  IGNORE_PROVISION = false
  # Means that all cluster IPs with start with CLUSTER_IP_PREFIX
  CLUSTER_IP_PREFIX = "192.168.3"
  # master will have 192.168.3.200, node1 .201, node2 .202 ips
  CLUSTER_NODE_IP_LESS_START = 200  
  # LoadBalancer wiil use IPs from 192.168.3.100 to 192.168.3.199
  CLUSTER_LOADBALANCER_IP_RANGE = "#{CLUSTER_IP_PREFIX}.100-#{CLUSTER_IP_PREFIX}.199"
  # Number of Cluster Nodes with be instanced.
  # Rebember than HA only available when nodes >= 3
  CLUSTER_INSTANCES = 3
  # NODE_NAME_PREFIX with contatenated to CLUSTER_NODE_IDX to create CLUSTER_NODE_NAME.
  # In this case hostnames with be [kdev1, kdev2, kdev3]
  NODE_NAME_PREFIX = "kdev"
  # Image of OS used to on virtualbox
  VM_OS = "ubuntu/xenial64"
  # Docker version for install - For last version just set VM_DOCKER_VER empty
  VM_DOCKER_VER = "18.06.2~ce~3-0~ubuntu"
  # Change docker deamon args to enable TCPIP access
  VM_DOCKER_DAEMON_ARGS = "-H fd:// -H tcp://#{CLUSTER_IP_PREFIX}.#{CLUSTER_NODE_IP_LESS_START}:4243"
  # Set VM_DNS_RESOLVER
  VM_DNS_RESOLVER = "8.8.8.8"
  # SSH-RSA OpenSSH to install on each cluster node sshd service
  VM_SSH_ACCESS_KEY ="/home/vagrant/provision/vitor_public_key.pub"  
  # Memory used by each Cluster node
  VM_MEMORY = 3072
  # K8s requires at least 2 CPUs
  # CPUS used by each Cluster node
  VM_CPUS = 2
  # List of shared folder between HOST computer and cluster nodes
  VM_SYNC_FOLDERS = [
    ["d:/WWW","/www"]
  ]
  ```

## Usage


1. Clone the repo and change to k8s-easy2 directory
    ```shell
    $ git clone https://github.com/vitorcool/k8s-easy2
    $ cd k8s-easy2
    ```
 Edit Vagrantfile to tuneup your cluster settings, or just skip this part and use default settings

2. Run the cluster
    ```shell
    $ vagrant up
    ```
    or
    ```shell
    $ vagrant up kdev1 # will UP only kdev1
    $ vagrant up    
    ```
2. Solve install probleams
    ```shell
    # There are 3 Provision script:
    #   1 bootstrap
    #   2 kube
    #   3 node

    # Remenber:
    # To be a Node, be kube first is a must
    # Even a Kube has to Bootstrap

    # So check instalation logs and :
    # Provision Kube with bootstrap - 1st provision
    $ vagrant up --provision-with bootstrap

    # OR

    # if bootstrap provision OK
    # Provision kube - 2st provision
    $ vagrant up --provision-with kube

    # OR

    # if Easy2 provision OK
    # Provision E kube - 2st provision
    $ vagrant up --provision-with kube
    ```
    or
    ```shell
    $ vagrant up kdev1 # will UP only kdev1
    $ vagrant up    
    ```

3. Access Master node
    ```shell
    $ vagrant ssh vdev1
    ```
4. Reboot Cluster
    ```shell
    $ vagrant reload    
    ```
4. Destroy Cluster
    $ vagrant destroy
    ```    
## Node Provision

### There are 3 Provision scripts:
||script | install phase
--- | --- | ---
|1|bootstrap | OS enviroment
|2|kube|Kubernetes Core
|3|node| Cluster setup - Master node and Slave node


1. Install provison - can solve problems
```shell
# Provision bootstrap - 1st provision
$ vagrant up --provision-with bootstrap
```
```shell
# if bootstrap provision OK
# Provision kube - 2st provision
$ vagrant up --provision-with kube
```
```shell
# if provision kube OK
# Provision E kube - 3td provision
$ vagrant up --provision-with kube
```
```shell
$ vagrant up kdev1 # will UP only kdev1
$ vagrant up    
```



## Inspired on code project :
  - [Git project](https://github.com/jonas-werner/k8s-home-lab-with-vagrant.git) https:\/\/github.com/jonas-werner/k8s-home-lab-with-vagrant.git
  - You shoud watch the following blog post and [videos](https://jonamiki.com/2019/11/09/kubernetes-home-lab-upgraded-edition-with-functional-loadbalancer-and-external-access-to-pods/) about this project

## Links
- [kubeadm](https://kubernetes.io/docs/admin/kubeadm/)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [Docker](https://docs.docker.com/)
