#!/bin/bash

set -e

sudo rm -f /tmp/disk*.qcow2 /tmp/test.iso 


sudo bash -x create-booteable-netinstall.sh \
	/home/diegows/isos/debian-8.6.0-amd64-netinst.iso /tmp/test.iso

qemu-img create -f qcow2 /tmp/disk1.qcow2 100G
qemu-img create -f qcow2 /tmp/disk2.qcow2 100G
qemu-img create -f qcow2 /tmp/disk3.qcow2 100G

kvm-spice -hda /tmp/disk1.qcow2 -hdb /tmp/disk2.qcow2 -hdd /tmp/disk3.qcow2 \
	-cdrom /tmp/test.iso -boot d -m 512

