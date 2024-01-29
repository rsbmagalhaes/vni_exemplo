//VPC + SUBNETS
resource "ibm_is_vpc" "vpc" {
  name = "vpc01"
}

resource "ibm_is_security_group" "sg01" {
  name = "sg01"
  vpc  = ibm_is_vpc.vpc.id
}

resource "ibm_is_security_group_rule" "sg-rule01" {
  group     = ibm_is_security_group.sg01.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_security_group_rule" "sg-rule02" {
  group     = ibm_is_security_group.sg01.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_subnet" "subnet01" {
  name              = "subnet01"
  vpc               = ibm_is_vpc.vpc.id
  zone              = local.zone1
  ipv4_cidr_block   = local.ipv4_cidr_block[local.zone1]
}

resource "ibm_is_subnet" "subnet02" {
  name              = "subnet02"
  vpc               = ibm_is_vpc.vpc.id
  zone              = local.zone2
  ipv4_cidr_block   = local.ipv4_cidr_block[local.zone2]
}

resource "ibm_is_public_gateway" "public_gateway01" {
  name              = "pg01"
  vpc               = ibm_is_vpc.vpc.id
  zone              = local.zone1
}

resource "ibm_is_public_gateway" "public_gateway02" {
  name              = "pg02"
  vpc               = ibm_is_vpc.vpc.id
  zone              = local.zone2
}

resource "ibm_is_subnet_public_gateway_attachment" "public-gateway-attachment01" {
  subnet            = ibm_is_subnet.subnet01.id
  public_gateway    = ibm_is_public_gateway.public_gateway01.id
}

resource "ibm_is_subnet_public_gateway_attachment" "public-gateway-attachment02" {
  subnet            = ibm_is_subnet.subnet02.id
  public_gateway    = ibm_is_public_gateway.public_gateway02.id
}