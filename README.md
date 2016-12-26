# Debian Preseed RAID5+LVM example

## Prerequisites

* syslinux and/or isolinux package
* genisolinux package
* Debian Jessie ISO netinstall

For testing purposes:

* kvm

## How to test it

```
./test.sh
```

## How to create the iso with the preseed file

```
./create-booteable-netinstall.sh /path/to/jessieiso /path/to/target.iso
```

## Bugs

* Installer is still asking for language when it starts.


## Author

Diego Woitasen <diego@flugel.it>
http://flugel.it
https://github.com/flugel-it

