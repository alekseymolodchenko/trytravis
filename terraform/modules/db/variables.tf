variable "zone" {
  description = "Zone"
}

variable "db_count" {
  description = "Database resource count"
  default     = 1
}

variable "env" {
  description = "Environment variable"
  default     = "stage"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable db_machine_type {
  description = "Machine type for application instance"
  default     = "g1-small"
}

variable "db_internal_ip" {
	description = "Database ip-address"
	default = "127.0.0.1"
}
