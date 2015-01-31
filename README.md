Gyrid
=====

Gyrid is a Bluetooth detection and analysis system and was the wife of Harald 'Bluetooth' Gormsson

Requirements
============

Gyrid is a set of bash scripts for Linux

Modern Linux installations probably already provide the BlueZ Bluetooth stack which offers these utilities

  * hcitools
  * l2ping

The device and detection data are recorded in JSON so you'll need

  * jshon

```
sudo apt-get install bluez jshon
```

Tested with
===========

Ubuntu 14.04 LTS

Building the test machine
=========================

Ingredients

  * Packard Bell EasyNote ENME69BMP netbook
  * 8Gb USB stick
  * Bluetooth 4.0 USB adapter

Software

  * Ubuntu 14.014 Desktop iso image
  * Pendrive Linux Creator

1 Download the Ubuntu image and Pendrive Linux Creator

2 Attach the 8Gb USB stick, start up Pendrive Linux Creator and create an Ubuntu USB stick

3 Amend the EasyNote BIOS settings to enable boot from USB

  * Select PC settings > Update & recovery > Recovery > Advanced startup
  * Wait for the netbook to restart
  * Select Troubleshoot > Advanced options > UEFI firmware settings
  * Wait for the netbook to restart, again

4 Reconfigure the InsydeH20 BIOS with the setup utility

  * In the Main screen, change F12 Boot Menu from disabled to enabled
  * In the Boot screen, change the boot order from
```
1 Windows Boot Manager
2 HDD
3 USB FDD
4 Net IPv4
5 USB HDD
6 USB CDROM
7 Net IPv6
```
to 
```
1 USB FDD
2 Windows Boot Manager
3 HDD
4 Net IPv4
5 USB HDD
6 USB CDROM
7 Net IPv6
```
  * Exit the InsydeH20 setup utility and save your changes

5 Restart the machine and install Ubuntu, deleting the entire drive

6 Attach the Bluetooth adapter

Second generation - Microprocessor
==================================

 - Raspberry Pi B+
 - Class 1  Bluetooth USB adapter
 
Installed Rasbian

Connect to network, SSH in and

```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo mkdir /var/log/gyrid
$ sudo chown -R pi:pi /var/log/gyrid
```
