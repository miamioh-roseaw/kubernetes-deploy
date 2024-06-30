variable "proxmox_api_url" {
  description = "Proxmox API URL"
}

variable "proxmox_username" {
  description = "Proxmox username"
}

variable "proxmox_password" {
  description = "Proxmox password"
}

variable "proxmox_node" {
  description = "Proxmox node name"
}

variable "master_count" {
  description = "Number of master nodes"
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  default     = 2
}

variable "vm_template" {
  description = "VM template to use for the nodes"
}

variable "vm_network" {
  description = "Network to attach the VMs to"
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the VMs"
}
