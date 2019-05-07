provider "google" {
  version = "1.20.0"
  project = "${var.project}"
  zone    = "${var.zone}"
}

resource "google_container_node_pool" "default_node_pool" {
  name       = "${var.k8s_node_pool_name}-${var.env}"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.k8s_node_pool_cont}"

  node_config {
    disk_size_gb = "${var.k8s_node_disk_size}"
    disk_type    = "${var.k8s_node_disk_type}"
    image_type   = "${var.k8s_node_image_type}"
    machine_type = "${var.k8s_node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  timeouts {
    create = "30m"
    update = "20m"
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_cluster" "primary" {
  name               = "${var.k8s_cluster_name}-${var.env}"
  initial_node_count = "${var.k8s_initial_node_count}"

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    disk_size_gb = "${var.k8s_node_disk_size}"
    disk_type    = "${var.k8s_node_disk_type}"
    image_type   = "${var.k8s_node_image_type}"
    machine_type = "${var.k8s_node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  enable_legacy_abac = true

  timeouts {
    create = "30m"
    update = "40m"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.k8s_cluster_name}-${var.env} --zone ${var.zone}"
  }

  provisioner "local-exec" {
    when = "destroy"
    on_failure = "continue"
    command = <<EOT
      kubectl config unset users.gke_${var.project}_${var.zone}_${var.k8s_cluster_name}-${var.env};
      kubectl config unset contexts.gke_${var.project}_${var.zone}_${var.k8s_cluster_name}-${var.env};
      kubectl config unset clusters.gke_${var.project}_${var.zone}_${var.k8s_cluster_name}-${var.env}
   EOT
  }
}

module "vpc" {
  source        = "./modules/vpc"
  source_ranges = "${var.source_ranges}"
  env           = "${var.env}"
}
