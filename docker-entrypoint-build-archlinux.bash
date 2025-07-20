#!/usr/bin/env bash

# #
# echo "
# ALL     ALL = (ALL) NOPASSWD: ALL" >>/etc/sudoers

# http://allanmcrae.com/2015/01/replacing-makepkg-asroot/
chgrp nobody ./
chmod a+rwxs --recursive ./
setfacl -m u::rwx,g::rwx ./
setfacl -d --set u::rwx,g::rwx,o::- ./

# https://bbs.archlinux.org/viewtopic.php?pid=1729990#p1729990
source PKGBUILD
pacman -Syu --noconfirm --needed --asdeps "${makedepends[@]}" "${depends[@]}"

runuser -u nobody -- ./bin-ensure-updated-source-to-build

runuser -u nobody -- makepkg

mv *.tar.* /github/workspace/
