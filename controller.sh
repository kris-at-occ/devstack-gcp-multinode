# Prepare the system

DEBIAN_FRONTEND=noninteractive sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y crudini git qemu-kvm bridge-utils libvirt-bin

externalip=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

# Clone devstack repo

git clone https://git.openstack.org/openstack-dev/devstack

cd devstack

# Prepare 'local.conf'
cat <<- EOF > local.conf
[[local|localrc]]
ADMIN_PASSWORD=openstack
DATABASE_PASSWORD=openstack
RABBIT_PASSWORD=openstack
SERVICE_PASSWORD=openstack
# Configure Nova novnc Proxy Base URL with External IP of this Instance
NOVNCPROXY_URL=http://$externalip:6080/vnc_auto.html
MULTI_HOST=1
EOF

./stack.sh

echo "You can access Horizon Dashboard at External IP address: http://$externalip/dashboard"
