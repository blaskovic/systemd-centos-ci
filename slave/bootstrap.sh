#!/usr/bin/sh

set -e

pr=$1

curl 'http://copr.fedorainfracloud.org/coprs/lnykryn/systemd-centosci-environment/repo/epel-7/lnykryn-systemd-centosci-environment-epel-7.repo' -o /etc/yum.repos.d/lnykryn-systemd-centosci-environment-epel-7.repo
yum -qy update
yum -qy install systemd-ci-environment

test -f systemd && rm -rf systemd
git clone https://github.com/systemd/systemd.git

cd systemd

git fetch -fu origin refs/pull/$pr/head:pr
git checkout pr

./autogen.sh
./configure CFLAGS='-g -O0 -ftrapv' --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64

make -j10
make install

# readahead is dead in systemd upstream
rm -f /usr/lib/systemd/system/systemd-readahead-done.service

