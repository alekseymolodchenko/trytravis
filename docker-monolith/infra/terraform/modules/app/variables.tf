variable zone {
  description = "Zone"
}

variable app_count {
  description = "Application instance count"
  default     = 1
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app with docker"
  default     = "reddit-app-docker"
}

variable app_machine_type {
  description = "Machine type for application instance"
  default     = "n1-standard-1"
}
