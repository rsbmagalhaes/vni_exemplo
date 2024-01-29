data "ibm_is_image" "image"{
    name = "ibm-centos-7-9-minimal-amd64-11"
}

data "ibm_is_zones" "zones" {
    region = var.region
}

data "ibm_is_ssh_key" "key" {
  name = "jorge-ssh-key"
}