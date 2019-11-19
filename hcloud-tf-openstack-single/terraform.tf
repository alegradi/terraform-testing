# Terraform playbook for used with Pluralshight's COA course
# ----------------------------------------------------------
# Ubuntu-16.04 - 4GB RAM - Single node - Private network 10.0.1.0/24


## Variables come here ##
variable "hcloud_token" {}

# Provider
provider "hcloud" {
  token 	= var.hcloud_token
}

# SSH key
data "hcloud_ssh_key" "centos7-terraform_key" {
  id		= "1121792"
}

# Node 1 configuration
resource "hcloud_server" "openstacksinglenode" {
  name        	= "openstacksinglenode"
  image       	= "centos-7"
  server_type 	= "cx21"
  ssh_keys    	= ["${data.hcloud_ssh_key.centos7-terraform_key.id}"]

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "yum update -y"
    ]
  }

}



# Private netwok configuration - needs further editing
resource "hcloud_network" "testnetwork" {
  name 		= "test-network"
  ip_range 	= "10.0.0.0/8"
}

resource "hcloud_network_subnet" "openstack_vlan" {
  network_id 	= hcloud_network.testnetwork.id
  network_zone 	= "eu-central"
  type 		= "server"
  ip_range   	= "10.0.1.0/24"
}

resource "hcloud_server_network" "srvnetwork1" {
  server_id 	= hcloud_server.openstacksinglenode.id
  network_id 	= hcloud_network.testnetwork.id
  ip 		= "10.0.1.5"
}


output "public_ip4_node1" {
  value 	= "${hcloud_server.openstacksinglenode.ipv4_address}"
}

