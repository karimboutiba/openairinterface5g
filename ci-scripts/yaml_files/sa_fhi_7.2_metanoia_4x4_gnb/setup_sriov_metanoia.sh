#!/bin/sh
# SPDX-License-Identifier: MIT

set -eu

IF_NAME=enp5s0f0np0
DPDK_DEVBIND_PREFIX=/usr/local/bin

#ethtool -G $IF_NAME rx 8160
#ethtool -G $IF_NAME tx 8160
sh -c "echo 0 > /sys/class/net/$IF_NAME/device/sriov_numvfs"
sh -c "echo 1 > /sys/class/net/$IF_NAME/device/sriov_numvfs"
modprobe -r iavf
modprobe iavf
# this next 2 lines is for C/U planes
ip link set $IF_NAME vf 0 mac 00:18:7d:3f:3c:cd vlan 601 qos 7 spoofchk off mtu 9216
sleep 1
# These are the DPDK bindings for C/U-planes on vlan 4
${DPDK_DEVBIND_PREFIX}/dpdk-devbind.py --unbind 05:02.0
modprobe vfio-pci
${DPDK_DEVBIND_PREFIX}/dpdk-devbind.py --bind vfio-pci 05:02.0
exit 0
