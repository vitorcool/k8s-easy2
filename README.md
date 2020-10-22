

# Project: k8s-devEasy2
-  Install
-  Define Cluster
-  Setup Kube CLUSTER_EXTERNAL_ADDRESSES
-  Test app

K8s / Kubernetes dev lab deployment
-
- Flannel for networking
- Metal LB for load balancing

(node formation)
"vagrant up" command will deploy with one K8s cluster
 [
- 1 master node
- 2 slave nodes  n={Vagrantfile.CLUSTER_INSTANCES} workers.
 All running Ubuntu and with VxLAN overlay networking.

## Inspired on code project : https://github.com/jonas-werner/k8s-home-lab-with-vagrant.git

Links
  https://github.com/jonas-werner/k8s-home-lab-with-vagrant.git
You shoud watch the following blog post and videos: https://jonamiki.com/2019/11/09/kubernetes-home-lab-upgraded-edition-with-functional-loadbalancer-and-external-access-to-pods/
"# k8s-easy2" 
