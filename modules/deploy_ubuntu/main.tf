variable "instance_count" {
  default = "2"
}

variable "instance_name" {
  type = list
  default = ["Web-app", "DB-App"]
}


provider "openstack" {
  cloud = "openstack"
}

resource "openstack_networking_subnet_v2" "tp-ynov-subnet" {
  name       = "tp-ynov-subnet"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "10.0.0.0/24"
  ip_version = 4
}

resource "openstack_blockstorage_volume_v2" "volume_1" {
  region      = "RegionOne"
  name        = "volume_1"
  description = "first test volume"
  size        = 10
}

resource "openstack_compute_instance_v2" "ubuntu22" {
  name = element(var.instance_name, count.index)
  count = var.instance_count
  image_id = "e22328df-50f3-4e1b-92e3-795b7eca522e"
  flavor_id = "c9a3d00a-f2b5-49a0-8326-0fbe0e18e00f"
  key_pair = "formation-keypair"
  security_groups = ["default"]
  volume_id = openstack_blockstorage_volume_v2.volume_1.id

  network {
    name = openstack_networking_network_v2.network_1.id
  }
}
