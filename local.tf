locals {
  ipv4_cidr_block = {
    "eu-es-1": "10.251.0.0/24",
    "eu-gb-1": "10.242.0.0/24",
    "eu-de-1": "10.243.0.0/24",
    "eu-es-2": "10.251.64.0/24",
    "eu-es-3": "10.251.128.0/24",
  }
  zone1 = data.ibm_is_zones.zones.zones[0]
  zone2 = data.ibm_is_zones.zones.zones[1]
}
