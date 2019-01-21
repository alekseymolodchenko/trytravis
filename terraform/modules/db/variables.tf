variable "zone" {
  description = "Zone"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable db_machine_type {
  description = "Machine type for application instance"
  default     = "g1-small"
}
