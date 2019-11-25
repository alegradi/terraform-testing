## Variables come here ##
variable "hcloud_token" {}
#variable "pvt_key" {}
#variable "pub_key" {}

# Provider
provider "hcloud" {
  token         = var.hcloud_token
}

# SSH key
data "hcloud_ssh_key" "centos7-terraform_key" {
  id            = "1121792"
}


