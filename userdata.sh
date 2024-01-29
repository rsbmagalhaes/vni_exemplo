#!/bin/bash
sleep 20
%{ for dev, addresses in secondary_ips ~}
   %{ for address in addresses ~}
      sudo ip addr add ${address} dev ${dev}
   %{ endfor ~}
%{ endfor ~}