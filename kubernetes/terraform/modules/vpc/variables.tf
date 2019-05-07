variable env {
  description = "Environment: production, development, staging"
  default     = "production"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}
