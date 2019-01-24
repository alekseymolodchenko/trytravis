variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable app_count {
  description = "Application resource count"
  default     = 1
}

variable db_count {
  description = "Database resource count"
  default     = 1
}

variable env {
  description = "Environment variable"
  default     = "prod"
}

variable "source_ranges" {
	description = "Allowed IP addresses"
  default     = ["93.159.232.194/32"]
}
