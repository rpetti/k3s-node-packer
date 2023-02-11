source "proxmox-iso" "k3s-node" {
    # proxmox settings
    insecure_skip_tls_verify = true
    proxmox_url = var.proxmox_url
    username = var.proxmox_username
    password = var.proxmox_password
    node = var.proxmox_node
    iso_url = var.iso_url
    iso_checksum = var.iso_checksum
    iso_storage_pool = var.proxmox_iso_storage_pool
    cpu_type = "host"
    memory = 1024
    os = "l26"
    template_name = "k3s-node-template-{{timestamp}}"
    unmount_iso = true
    onboot = true
    qemu_agent = true
    network_adapters {
        bridge = "vmbr0"
        model = "virtio"
    }
    disks {
        storage_pool = var.proxmox_storage_pool
        storage_pool_type = var.proxmox_storage_pool_type
        disk_size = "32G"
        format = "raw"
    }
    boot_wait = "20s"
    boot_command = [
        "<wait>",
        "root<enter><wait>",
        "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
        "setup-apkrepos -1<enter><wait5>",
        "cat << EOF > answers<enter>",
        "KEYMAPOPTS=\"us us\"<enter>",
        "HOSTNAMEOPTS=\"-n alpine\"<enter><wait>",
        "INTERFACESOPTS=\"auto lo<enter>",
        "iface lo inet loopback<enter>",
        "auto eth0<enter>",
        "iface eth0 inet dhcp<enter>",
        "\"<enter><wait>",
        "TIMEZONEOPTS=\"-z UTC\"<enter>",
        "PROXYOPTS=\"none\"<enter>",
        "APKREPOSOPTS=\"-1\"<enter>",
        "SSHDOPTS=\"-c openssh\"<enter>",
        "NTPOPTS=\"-c openntpd\"<enter><wait>",
        "DISKOPTS=\"-m sys /dev/sda\"<enter>",
        "EOF<enter><wait>",
        "ERASE_DISKS=/dev/sda setup-alpine -f answers<enter><wait5>",
        "${var.ssh_password}<enter><wait>",
        "${var.ssh_password}<enter><wait>",
        "<enter><wait2m>",
        "mount /dev/sda3 /mnt<enter>",
        "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>",
        "chroot /mnt /bin/ash<enter>",
        "sed -i -e '/v3....community/s/^#//' /etc/apk/repositories<enter>",
        "apk add --no-cache qemu-guest-agent<enter><wait20s>",
        "rc-update add qemu-guest-agent boot<enter>",
        "exit<enter>",
        "umount /mnt<enter><wait>",
        "reboot<enter>"
    ]
    communicator = "ssh"
    ssh_username = var.ssh_username
    ssh_password = var.ssh_password
    cloud_init = true
    cloud_init_storage_pool = var.proxmox_storage_pool
}

build {
    sources = ["source.proxmox-iso.k3s-node"]
    provisioner "shell" {
        environment_vars = [
            "K3S_URL=${var.K3S_URL}",
            "K3S_TOKEN=${var.K3S_TOKEN}"
        ]
        scripts = [
            "scripts/k3s-requirements.sh",
            "scripts/k3s-join.sh"
        ]
    }
}