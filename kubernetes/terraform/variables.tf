variable project {
  description = "Project ID"
}

variable zone {
  description = "Zone"
  default     = "europe-west6-a"
}

variable "k8s_cluster_name" {
  description = "Cluster name"
}

variable "k8s_node_pool_name" {
  description = "Node pool name"
}

variable "k8s_node_machine_type" {
  description = "Node machine type"
  default     = "n1-standard-1"
}

variable "k8s_initial_node_count" {
  description = "Cluster initian node count"
  default     = 1
}

variable "k8s_node_pool_cont" {
  description = "Cluster node pool count"
  default     = 2
}
