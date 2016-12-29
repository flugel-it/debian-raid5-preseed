#!/bin/bash

set -e

ISO=$1
OUT=$2

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script must be run with root privilege. Trying to sudo command."
    exit -1
fi

if [ ! -f /usr/lib/ISOLINUX/isolinux.bin ]; then
    echo "isolinux.bin file missing."
    exit -1
fi

if [ ! -f /usr/bin/genisoimage ]; then
    echo "genisoimage command missing."
    exit -1
fi

TMPMNT=$(mktemp -d)
BUILD=/tmp/bootstrap

mount -o loop $ISO $TMPMNT
rsync -va --delete ${TMPMNT}/ ${BUILD}/

echo "copy isolinux files..."
mkdir -p $BUILD/scripts $BUILD/isolinux $BUILD/preseed || true
cp raid5.seed $BUILD/preseed

cat > $BUILD/isolinux/isolinux.cfg << EOF

CONSOLE 0
SERIAL 0 115200 0

prompt 0
default debian-raid5-flugel
timeout 100

label debian-raid5-flugel
kernel /install.amd/vmlinuz
append initrd=/install.amd/initrd.gz file=/cdrom/preseed/raid5.seed debian-installer/language=en debian-installer/locale=en_US debian-installer/country=US debian-installer/keymap=us keymap=us

EOF

echo "Creating iso image..."
cd $BUILD/isolinux
genisoimage -q -V "DebianNetInstall" \
	-o $OUT \
	-b isolinux/isolinux.bin -c boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table -r -J \
       	$BUILD
cd -
echo "ISO Done!"

umount $TMPMNT
rmdir $TMPMNT
echo "clean up..."
rm -fr $BUILD

