#! /bin/sh

# Check for required environment variables

if [ -z "$externalip" ]; then
  echo "Please set \$externalip"
  exit 1
fi

if [ -z "$servicehost" ]; then
  echo "Please set \$servicehost"
  exit 1
fi

echo "Test ping controller"
ping -c 1 controller

if [ $? -ne 0 ]; then
  echo "Please make sure controller is defined in /etc/hosts and connectivity is enabled"
  exit 1
fi

# Prepare the system

DEBIAN_FRONTEND=noninteractive sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y crudini git qemu-kvm bridge-utils libvirt-bin

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
MULTI_HOST=1
DATABASE_TYPE=mysql
SERVICE_HOST=$servicehost
MYSQL_HOST=$SERVICE_HOST
RABBIT_HOST=$SERVICE_HOST
GLANCE_HOSTPORT=$SERVICE_HOST:9292
ENABLED_SERVICES=n-cpu,q-agt,n-api-meta,c-vol,placement-client
NOVA_VNC_ENABLED=True
NOVNCPROXY_URL="http://$externalip:6080/vnc_auto.html"
VNCSERVER_LISTEN=$HOST_IP
VNCSERVER_PROXYCLIENT_ADDRESS=$VNCSERVER_LISTEN
EOF

./stack.sh
