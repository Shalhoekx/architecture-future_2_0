# Настройка провайдера

terraform {
  required_providers {
    yandex    = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.47.0"
    }
  }
}

provider "yandex" {
  token="t1.9euelZqbxs7GmpyezMzKmZGRms2VzO3rnpWam8rMkJfLxp7IloyVi5SelZfl8_dKADoz-e9WdAQd_t3z9wovNzP571Z0BB3-.ny5I0ZC5z3Rfw6f-" # yc create token
  zone = var.zone
}

# Создание репозитория Сontainer Registry

resource "yandex_container_registry" "my-registry" {
  name       = var.registry_name
  folder_id  = var.target_folder_id
}

# Создание сервисного аккаунта

resource "yandex_iam_service_account" "registry-sa" {
  name      = var.sa_name
  folder_id = var.target_folder_id
}

# Назначение роли сервисному аккаунту

resource "yandex_resourcemanager_folder_iam_member" "registry-sa-role-images-puller" {
  folder_id = var.target_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.registry-sa.id}"
}

# Создание облачной сети

resource "yandex_vpc_network" "docker-vm-network" {
  name = var.network_name
  folder_id = var.target_folder_id
}

# Создание подсети

resource "yandex_vpc_subnet" "docker-vm-network-subnet-a" {
  name           = var.subnet_name
  zone           = var.zone
  v4_cidr_blocks = ["192.168.1.0/24"]
  network_id     = yandex_vpc_network.docker-vm-network.id
  folder_id = var.target_folder_id
}

# Создание загрузочного диска

resource "yandex_compute_disk" "boot-disk" {
  name     = "bootvmdisk"
  type     = "network-hdd"
  zone     = var.zone
  size     = "10"
  image_id = var.image_id
  folder_id = var.target_folder_id
}

# Создание ВМ

resource "yandex_compute_instance" "docker-vm" {
  name               = var.vm_name
  platform_id        = "standard-v3"
  zone               = var.zone
  service_account_id = "${yandex_iam_service_account.registry-sa.id}"
  folder_id = var.target_folder_id

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.docker-vm-network-subnet-a.id}"
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.username}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_key_path}")}"
  }
}
