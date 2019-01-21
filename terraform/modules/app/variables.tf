variable "zone" {
  description = "Zone"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable app_machine_type {
  description = "Machine type for application instance"
  default     = "g1-small"
}
