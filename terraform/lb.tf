resource "google_compute_forwarding_rule" "default" {
  name                  = "reddit-app"
  description           = "reddit app forwarding rule"
  port_range            = "9292"
  target                = "${google_compute_target_pool.default.self_link}"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_pool" "default" {
  name          = "reddit-app-instances"
  description   = "reddit app instance pool"
  instances     = ["${google_compute_instance.app.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.default.name}"]
}

resource "google_compute_http_health_check" "default" {
  name                = "health-check-reddit-app"
  port                = 9292
  check_interval_sec  = 10
  timeout_sec         = 5
  unhealthy_threshold = 5
}
