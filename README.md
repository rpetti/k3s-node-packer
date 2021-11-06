# K3S Node for Proxmox with Packer

This is a packer build for creating a k3s agent/node template on Proxmox.

When a VM is cloned from the template and started, it will automatically join the cluster.

## Usage

Create a file for your connection information/secrets:

`proxmox.pkrvars.hcl`
```hcl
proxmox_url = "https://proxmox.lan:8006/api2/json"
proxmox_username = "root@pam"
proxmox_password = ""
proxmox_node = "proxmox"
proxmox_iso_storage_pool = "slow"
proxmox_storage_pool = "fast"
proxmox_storage_pool_type = "lvm-thin"

ssh_password="newPasswordForAgent"

K3S_URL = "https://rancher.lan:6443"
K3S_TOKEN = "yourK3Stoken"
```

`K3S_TOKEN` can be found on your k3s master nodes in `/var/lib/rancher/k3s/server/node-token`

Run packer:

```bash
packer build -var-file=proxmox.pkrvars.hcl .
```