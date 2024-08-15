#!/bin/bash

. /pkgscripts/include/pkg_util.sh

package="zfs"
version="2.2.5-0001"
os_min_ver="7.0-40761"
description="OpenZFS is storage software which combines the functionality of traditional filesystems, volume manager, and more."
arch="$(pkg_get_platform)"
maintainer="jacob berkman"

displayname="OpenZFS"
maintainer_url="https://github.com/jberkman/synozfs"
support_url="https://github.com/jberkman/synozfs/issues"
ctl_stop="no"
beta="yes"
install_type="system"
thirdparty="yes"

[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
