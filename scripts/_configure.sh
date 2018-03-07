#!/bin/bash
#
# This script is run by vagrant on startup.  Do not run it.
#

set -eou pipefail
IFS=$'\n\t'

hosts=${1:-}
baseip=${2:-}

usage () {
    echo "usage: $0 host ip"
}

if [[ -z "$hosts" ]]; then
    usage
    exit 1
fi

if [[ -z "$baseip" ]]; then
    usage
    exit 1
fi

if grep vagrant /home/vagrant/.ssh/authorized_keys > /dev/null; then
  echo "Disabling swap"
  swapoff -a
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  echo "Setting noop scheduler"
  echo noop > /sys/block/sda/queue/scheduler
  echo  "Disabling IPv6"
  cat << EOF >> /etc/sysctl.conf
  net.ipv6.conf.all.disable_ipv6 = 1
  net.ipv6.conf.default.disable_ipv6 = 1
  net.ipv6.conf.lo.disable_ipv6 = 1
EOF
  sysctl -p
fi

#echo "$baseip.100 control" > /etc/hosts
#for i in $(seq -f "%02g" 1 $hosts); do
#  suffix="$((100 + $i))"
#  echo "$baseip.$suffix"  node-$i >> /etc/hosts
#done
