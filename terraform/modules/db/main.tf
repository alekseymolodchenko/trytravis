resource "google_compute_instance" "db" {
  count        = "${var.db_count}"
  name         = "reddit-db-${var.env}-${format("%02d", count.index+1)}"
  machine_type = "${var.db_machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

	# connection {
  #   type        = "ssh"
  #   user        = "appuser"
  #   agent       = false
  #   private_key = "${file(var.private_key_path)}"
  # }

	# provisioner "file" {
  #   source      = "../modules/db/files/deploy.sh"
  #   destination = "/tmp/deploy.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/deploy.sh",
  #     "sudo /tmp/deploy.sh ${self.network_interface.0.address}"
  #   ]
  # }
}
