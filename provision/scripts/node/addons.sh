#
# k8sEasy2
#
dd=/home/vagrant
. $dd/provision/scripts/_comum.sh

echo "------------------------------------------------- Configuring Master node"
echo "USER: $(whoami)"
echo "DIRECTORY: $(pwd)"
echo "-------------------------------------------------------------------------"


$dd/provision/addons/flannel/install
$dd/provision/addons/metallb/install
$dd/provision/addons/helm3/install
$dd/provision/addons/dashboard/install
