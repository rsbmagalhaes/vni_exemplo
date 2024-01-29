//vNIC's
resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi01_01" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi01-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi01_02" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi01-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi01_03" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi01-03"
}

resource "ibm_is_virtual_network_interface" "vnic01-vsi01" {
  allow_ip_spoofing = false 
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic01-vsi01"
  subnet = ibm_is_subnet.subnet01.id
  security_groups = [ibm_is_security_group.sg01.id]
  resource_group = data.ibm_resource_group.group.id
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi01_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi01_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi01_03.reserved_ip
  }
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi02_01" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi02-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi02_02" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi02-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi02_03" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi02-03"
}

resource "ibm_is_virtual_network_interface" "vnic01-vsi02" {
  allow_ip_spoofing = false
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic01-vsi02"
  subnet = ibm_is_subnet.subnet02.id
  security_groups = [ibm_is_security_group.sg01.id]
  resource_group = data.ibm_resource_group.group.id
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi02_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi02_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi02_03.reserved_ip
  }
}

//VSI's
resource "ibm_is_instance" "vsi01" {
  name              = "vsi01"
  image             = data.ibm_is_image.image.id
  profile           = "cx2-2x4"
  primary_network_attachment {
    name = "vsi01-nic01"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.vnic01-vsi01.id
    }
  }
  vpc               = ibm_is_subnet.subnet01.vpc
  zone              = local.zone1
  keys              = [data.ibm_is_ssh_key.key.id]
  user_data         = templatefile("userdata.sh", {
    secondary_ips = {
      "eth0": [for i in ibm_is_virtual_network_interface.vnic01-vsi01.ips: i.address]
    }
  })
}

resource "ibm_is_instance" "vsi02" {
  name              = "vsi02"
  image             = data.ibm_is_image.image.id
  profile           = "cx2-2x4"
  primary_network_attachment {
    name = "vsi02-nic01"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.vnic01-vsi02.id
    }
  }
  vpc               = ibm_is_subnet.subnet02.vpc
  zone              = local.zone2
  keys              = [data.ibm_is_ssh_key.key.id]
  user_data         = templatefile("userdata.sh", {
    secondary_ips = {
      "eth0": [for i in ibm_is_virtual_network_interface.vnic01-vsi02.ips: i.address]
    }
  })
}

//Floating IP's
resource "ibm_is_floating_ip" "floating01" {
  name   = "floating01"
  zone = local.zone1
}

resource "ibm_is_virtual_network_interface_floating_ip" "float01"{
  virtual_network_interface = ibm_is_virtual_network_interface.vnic01-vsi01.id
  floating_ip = ibm_is_floating_ip.floating01.id
}

resource "ibm_is_floating_ip" "floating02" {
  name   = "floating02"
  zone = local.zone2
}

resource "ibm_is_virtual_network_interface_floating_ip" "float02"{
  virtual_network_interface = ibm_is_virtual_network_interface.vnic01-vsi02.id
  floating_ip = ibm_is_floating_ip.floating02.id
}