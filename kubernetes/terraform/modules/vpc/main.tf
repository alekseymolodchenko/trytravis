resource "google_compute_firewall" "k8s_firewall_rules" {
  name        = "default-allow-k8s-${var.env}"
  network     = "default"
  description = "Allow k8s from internet"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = "${var.source_ranges}"
}
