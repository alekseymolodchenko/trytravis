terraform {
  backend "gcs" {
    bucket = "terraform-2-otus-storage-state-bucket"
    prefix = "stage"
  }
}
