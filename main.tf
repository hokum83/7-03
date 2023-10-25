terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "web" {
  count = var.icount
  name  = "terraform-web${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.network_interface.0.nat_ip_address},' ./playbooks/web.yml"
  }

}

resource "yandex_compute_instance" "db" {
  count = var.icount
  name  = "terraform-db${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.network_interface.0.nat_ip_address},' ./playbooks/db.yml"
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_addresses_web" {
  value = yandex_compute_instance.web[*].network_interface.0.ip_address
}
output "external_ip_addresses_web" {
  value = yandex_compute_instance.web[*].network_interface.0.nat_ip_address
}
output "internal_ip_addresses_db" {
  value = yandex_compute_instance.db[*].network_interface.0.ip_address
}
output "external_ip_addresses_db" {
  value = yandex_compute_instance.db[*].network_interface.0.nat_ip_address
}
