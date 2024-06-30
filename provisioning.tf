resource "null_resource" "k8s_master_provision" {
  count = var.master_count

  connection {
    type     = "ssh"
    host     = proxmox_vm_qemu.k8s_master.*.network_interface[0].ip[count.index]
    user     = "ubuntu"
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "kube_init.sh"
    destination = "/tmp/kube_init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kube_init.sh",
      "/tmp/kube_init.sh master"
    ]
  }
}

resource "null_resource" "k8s_worker_provision" {
  count = var.worker_count

  connection {
    type     = "ssh"
    host     = proxmox_vm_qemu.k8s_worker.*.network_interface[0].ip[count.index]
    user     = "ubuntu"
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "kube_init.sh"
    destination = "/tmp/kube_init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/kube_init.sh",
      "/tmp/kube_init.sh worker"
    ]
  }

  depends_on = [null_resource.k8s_master_provision]
}
