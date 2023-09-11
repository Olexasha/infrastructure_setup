#terraform {
#  required_providers {
#    yandex = {
#      source  = "yandex-cloud/yandex"
#      version = "0.95.0"
#    }
#  }
#  required_version = ">= 1.5.1"
#}

provider "yandex" {
  token     = var.token_id
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "app" {
  zone  = var.zone
  name  = "reddit-app-${count.index}"
  count = var.vm_count

  # --------------------------------HW / Boot --------------------------------
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      # Указан id образа
      image_id = var.image_id
    }
  }
  # --------------------------------Network Configuration --------------------------------
  network_interface {
    # Указан id подсети kek-network-1-ru-central1-a
    subnet_id = var.subnet_id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }
  # --------------------------------Provisioners --------------------------------
  provisioner "file" {
    source      = "./files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "./files/deploy.sh"
  }

}
