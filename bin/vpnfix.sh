#!/bin/bash

# VPN Fix
sudo ip link set mtu 1360 eth0

# Disable IPv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# Restart networking to make sure changes applied
/etc/init.d/networking restart
