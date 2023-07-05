resource "openstack_compute_instance_v2" "ubuntu" {
  name = "ubuntu"
  image_id = ""
  flavor_id = ""
  key_pair = ""
  security_groups = []

  network {
    name = ""
  }
}