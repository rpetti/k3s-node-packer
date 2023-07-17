variable "proxmox_url" {}
variable "proxmox_username" {}
variable "proxmox_password" {}
variable "proxmox_node" {}
variable "proxmox_iso_storage_pool" {}
variable "proxmox_storage_pool" {
    default = "local-lvm"
}
variable "proxmox_storage_pool_type" {
    default = "lvm-thin"
}
variable "boot_wait" {
    default = "10"
}
variable "ssh_username" {
    default = "root"
    type = string
}
variable "ssh_password" {
    default = "password"
    type = string
}
variable "K3S_URL" {
    type = string
}
variable "K3S_TOKEN" {
    type = string
}
variable "iso_url" {
    type = string
    default = "https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-standard-3.18.2-x86_64.iso"
} 
variable "iso_checksum" {
    type = string
    default = "513dfc3c0c516b803095cd829df72cea956757316247584f0f2ddde7e5b0262f"
}