# Hetzner Cloud Web Server for Production testing
#


# Node 1 configuration
resource "hcloud_server" "web-prod1" {
  name        	= "web-prod1"
  image       	= "centos-7"
  server_type 	= "cx11"
  ssh_keys    	= ["${data.hcloud_ssh_key.centos7-terraform_key.id}"]
}



# Private netwok configuration - needs further editing
resource "hcloud_network" "testnetwork" {
  name 		= "test-network"
  ip_range 	= "10.0.0.0/8"
}

resource "hcloud_network_subnet" "test_vlan" {
  network_id 	= hcloud_network.testnetwork.id
  network_zone 	= "eu-central"
  type 		= "server"
  ip_range   	= "10.0.2.0/24"
}

resource "hcloud_server_network" "srvnetwork1" {
  server_id 	= hcloud_server.web-prod1.id
  network_id 	= hcloud_network.testnetwork.id
  ip 		= "10.0.2.1"
}


output "public_ip4_node1" {
  value 	= "${hcloud_server.web-prod1.ipv4_address}"
}

