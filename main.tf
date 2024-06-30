resource "proxmox_vm_qemu" "k8s_master" {
  count      = var.master_count
  name       = "k8s-master-${count.index + 1}"
  target_node = var.proxmox_node
  clone      = var.vm_template

  os_type    = "cloud-init"
  cores      = 2
  memory     = 4096
  network {
    model = "virtio"
    bridge = var.vm_network
  }

  ipconfig0 = "ip=dhcp"

  sshkeys = var.ssh_public_key

  ciuser = "ubuntu"
  cipassword = "ubuntu"

  lifecycle {
    create_before_destroy = true
  }
}

resource "proxmox_vm_qemu" "k8s_worker" {
  count      = var.worker_count
  name       = "k8s-worker-${count.index + 1}"
  target_node = var.proxmox_node
  clone      = var.vm_template

  os_type    = "cloud-init"
  cores      = 2
  memory     = 4096
  network {
    model = "virtio"
    bridge = var.vm_network
  }

  ipconfig0 = "ip=dhcp"

  sshkeys = var.ssh_public_key

  ciuser = "ubuntu"
  cipassword = "ubuntu"

  lifecycle {
    create_before_destroy = true
  }
}

output "master_ips" {
  value = ["${proxmox_vm_qemu.k8s_master.*.network_interface[0].ip}"]
}

output "worker_ips" {
  value = ["${proxmox_vm_qemu.k8s_worker.*.network_interface[0].ip}"]
}
