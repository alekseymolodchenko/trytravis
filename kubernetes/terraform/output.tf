output "k8s_client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "k8s_client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "k8s_cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
