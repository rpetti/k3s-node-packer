#!/bin/sh

apk add --no-cache ca-certificates curl nfs-utils cloud-init cni-plugins iptables fuse-overlayfs
setup-cloud-init

sed -ie '/^default_kernel_opts/s/"$/ cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"/' /etc/update-extlinux.conf
update-extlinux
#echo "cgroup /sys/fs/cgroup cgroup defaults 0 0" >> /etc/fstab
echo 'rc_cgroup_mode="unified"' >> /etc/rc.conf

cat > /etc/cgconfig.conf <<EOF
mount {
  cpuacct = /cgroup/cpuacct;
  memory = /cgroup/memory;
  devices = /cgroup/devices;
  freezer = /cgroup/freezer;
  net_cls = /cgroup/net_cls;
  blkio = /cgroup/blkio;
  cpuset = /cgroup/cpuset;
  cpu = /cgroup/cpu;
}
EOF