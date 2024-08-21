# OpenZFS for Synology DiskStation Manager

This package contains kernel modules and userspace tools for
[OpenZFS](https://openzfs.org/).

## Motivation

The goal for this project was to host Apple macOS Time Machine backups on ZFS over Tailscale. General use as a replacement for btrfs/ext4 was not considered, although known incompatibilities can be found at [GitHub Issues](https://github.com/jberkman/synozfs/issues).

Due to restrictions on DiskStation Manager packages, a post-install script must be run manually as root. In addition, OpenZFS command-line tools are needed to configure pools and filesystems. **You should only use this tool if you're comfortable using ssh and the commandline on your DiskStation.**

Note that DiskStation Manager will want a non-ZFS storage pool. I have a 4-bay model, and used 2 drives for a mirrored non-ZFS pool, and 2 larger drives for a mirrored ZFS pool. You can put both types of pools on each drive, however this has not been tested.

## Building

### Synology Build Environment

See [Synology Package Developer Guide](https://help.synology.com/developer-guide/getting_started/prepare_environment.html) for instructions on setting up your development environment.

### Building the OpenZFS Package

Check out this repo into your toolkit environment (replacing "7.2" and "apollolake" with your DSM version and platform, and "2.2.5" with the desired OpenZFS release):

```
$ cd /toolkit/source
$ git clone https://github.com/jberkman/synozfs.git zfs
...
```

Download the desired release of OpenZFS:

```
$ cd /toolkit/source/zfs
$ wget https://github.com/openzfs/zfs/releases/download/zfs-2.2.5/zfs-2.2.5.tar.gz
...
```

Build the OpenZFS package:

```
$ sudo /toolkit/pkgscripts-ng/PkgCreate.py -v 7.2 -p apollolake -c zfs
...
```

The resulting package is found in `/toolkit/result_spk/zfs-2.2.5-0001/zfs-x86_64-2.2.5-0001.spk` (or similar).

## Installation

Install the package on your DiskStation:

1. Open Package Center
2. Click Manual Install in the upper right
3. Select the package file built in the previous step
4. A third-party developer warning dialog will appear
5. Click Agree
6. Check "I accept the terms of the license agreement" and click Next
7. Click Done

To complete installation, run the post-installation script as root:

```
$ ssh diskstation
...
user@diskstation:~$ sudo /var/packages/zfs/scripts/postinst
...
```

Reboot, either using the command-line or the admin console.

## Configuration

Search the Web for existing tutorials on configuration of ZFS pools and filesystems.

## SMB Sharing

I was not able to get the Synology Samba server to work well with ZFS, so made a [Samba Docker package](https://github.com/jberkman/samba.docker) to provide the Time Machine SMB shares.
