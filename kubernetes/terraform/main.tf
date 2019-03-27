resource "google_container_cluster" "primary" {
  name    = "${var.k8s_cluster_name}"
  project = "${var.project}"
  zone    = "${var.zone}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  initial_node_count = "${var.k8s_initial_node_count}"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name = "${var.k8s_node_pool_name}"

  project    = "${var.project}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.k8s_node_pool_cont}"

  node_config {
    preemptible  = true
    machine_type = "${var.k8s_node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
