resource "google_compute_instance" "app" {
  count        = "${var.app_count}"
  name         = "reddit-app-docker-${format("%02d", count.index+1)}"
  machine_type = "${var.app_machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-app-docker"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}
