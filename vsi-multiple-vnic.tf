//vNIC's
resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi03_01" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi03-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi03_02" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi03-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi03_03" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic01-vsi03-03"
}

resource "ibm_is_virtual_network_interface" "vnic01-vsi03" {
  allow_ip_spoofing = false 
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic01-vsi03"
  subnet = ibm_is_subnet.subnet01.id
  security_groups = [ibm_is_security_group.sg01.id]
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi03_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi03_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi03_03.reserved_ip
  }
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi03_01" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic02-vsi03-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi03_02" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic02-vsi03-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi03_03" {
 subnet = ibm_is_subnet.subnet01.id
 name = "rip-vnic02-vsi03-03"
}

resource "ibm_is_virtual_network_interface" "vnic02-vsi03" {
  allow_ip_spoofing = false 
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic02-vsi03"
  subnet = ibm_is_subnet.subnet01.id
  security_groups = [ibm_is_security_group.sg01.id]
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi03_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi03_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi03_03.reserved_ip
  }
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi04_01" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi04-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi04_02" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi04-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic01_vsi04_03" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic01-vsi04-03"
}

resource "ibm_is_virtual_network_interface" "vnic01-vsi04" {
  allow_ip_spoofing = false
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic01-vsi04"
  subnet = ibm_is_subnet.subnet02.id
  security_groups = [ibm_is_security_group.sg01.id]
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi04_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi04_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic01_vsi04_03.reserved_ip
  }
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi04_01" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic02-vsi04-01"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi04_02" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic02-vsi04-02"
}

resource "ibm_is_subnet_reserved_ip" "rip_vnic02_vsi04_03" {
 subnet = ibm_is_subnet.subnet02.id
 name = "rip-vnic02-vsi04-03"
}

resource "ibm_is_virtual_network_interface" "vnic02-vsi04" {
  allow_ip_spoofing = false
  auto_delete = false
  enable_infrastructure_nat = true
  name = "vnic02-vsi04"
  subnet = ibm_is_subnet.subnet02.id
  security_groups = [ibm_is_security_group.sg01.id]
  primary_ip {
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi04_01.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi04_02.reserved_ip
  }
  ips{
    reserved_ip = ibm_is_subnet_reserved_ip.rip_vnic02_vsi04_03.reserved_ip
  }
}

//VSI's
resource "ibm_is_instance" "vsi03" {
  name              = "vsi03"
  image             = data.ibm_is_image.image.id
  profile           = "cx2-2x4"
  primary_network_attachment {
    name = "vsi03-nic01"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.vnic01-vsi03.id
    }
  }
  vpc               = ibm_is_subnet.subnet01.vpc
  zone              = local.zone1
  keys              = [data.ibm_is_ssh_key.key.id]
  user_data         = templatefile("userdata.sh", {
    secondary_ips = {
      "eth0": [for i in ibm_is_virtual_network_interface.vnic01-vsi03.ips: i.address]
      "eth1": [for i in ibm_is_virtual_network_interface.vnic02-vsi03.ips: i.address]
    }
  })
}

resource "ibm_is_instance_network_attachment" "example" {
  instance = ibm_is_instance.vsi03.id
  virtual_network_interface { 
    id = ibm_is_virtual_network_interface.vnic02-vsi03.id
  } 
}

resource "ibm_is_instance" "vsi04" {
  name              = "vsi04"
  image             = data.ibm_is_image.image.id
  profile           = "cx2-2x4"
  primary_network_attachment {
    name = "vsi04-nic01"
    virtual_network_interface {
      id = ibm_is_virtual_network_interface.vnic01-vsi04.id
    }
  }
  vpc               = ibm_is_subnet.subnet02.vpc
  zone              = local.zone2
  keys              = [data.ibm_is_ssh_key.key.id]
  user_data         = templatefile("userdata.sh", {
    secondary_ips = {
      "eth0": [for i in ibm_is_virtual_network_interface.vnic01-vsi04.ips: i.address]
      "eth1": [for i in ibm_is_virtual_network_interface.vnic02-vsi04.ips: i.address]
    }
  })
}

resource "ibm_is_instance_network_attachment" "attachment04" {
  instance = ibm_is_instance.vsi04.id
  virtual_network_interface { 
    id = ibm_is_virtual_network_interface.vnic02-vsi04.id
  } 
}

//Floating IP's
resource "ibm_is_floating_ip" "floating03" {
  name   = "floating03"
  zone = local.zone1
}

resource "ibm_is_virtual_network_interface_floating_ip" "float03"{
  virtual_network_interface = ibm_is_virtual_network_interface.vnic01-vsi03.id
  floating_ip = ibm_is_floating_ip.floating03.id
}

resource "ibm_is_floating_ip" "floating04" {
  name   = "floating04"
  zone = local.zone2
}

resource "ibm_is_virtual_network_interface_floating_ip" "float04"{
  virtual_network_interface = ibm_is_virtual_network_interface.vnic01-vsi04.id
  floating_ip = ibm_is_floating_ip.floating04.id
}