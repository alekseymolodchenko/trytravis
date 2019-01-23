variable zone {
  description = "Zone"
}

variable app_count {
  description = "Application resource count"
  default     = 1
}

variable env {
  description = "Environment variable"
  default     = "stage"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable app_machine_type {
  description = "Machine type for application instance"
  default     = "g1-small"
}

variable "db_address" {
	description = "Database Ip Address"
}
