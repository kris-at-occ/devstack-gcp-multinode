# devstack-gcp-multinode
Scripts to install multinode Devstack in GCP Virtual Machine

In GCP Console go to VPC Network -> Firewall rules

Create Firewall Rule

- Name: allownovnc
- Ingress
- Allow
- Targets: All Instances
- Source IP ranges: 0.0.0.0/0
- Protocols and Ports: tcp/6080

Create Custome Image, based on Ubuntu 16.04 with Nested Virtualization enabled. Here is the instruction:
https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances

In Compute Engine Create a new VMs

- Name: controller
- Region: most suitable
- Machine type: 2 vCPUs 7.5 GB memory (n1-standard-2) or 2 vCPUs 13 GB memory (n1-highmem-2)
- Boot disk: your customer image, 30GB disk (Standard or SSD)
- Firewall: Allow HTTP and HTTPS traffic


- Name: compute
- Region: most suitable
- Machine type: 2 vCPUs 7.5 GB memory (n1-standard-2) or 2 vCPUs 13 GB memory (n1-highmem-2)
- Boot disk: your custom image, 30GB disk (Standard or SSD)
- Firewall: Allow HTTP and HTTPS traffic

Open consoles, edit /etc/hosts to include both nodes, enable passwordless SSH for default user.

Clone this repo in both nodes:


`git clone https://github.com/kris-at-occ/devstack-gcp-multinode`


Run script to install Devstack on <b>controller</b> node:


`sh devstack-gcp-multinode/controller.sh`


The script displays Horizon Dashboard URL in the very last line of the output.

Run script to install Devstack in <b>compute</b> node:

`sh devstack-gcp-multinode/compute.sh`


Enjoy!
