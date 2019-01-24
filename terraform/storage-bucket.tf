provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_storage_bucket" "storage-bucket" {
  name = "terraform-2-otus-storage-state-bucket"
}

resource "google_storage_bucket_acl" "terraform-2-otus-storage-state-bucket-acl" {
  bucket         = "${google_storage_bucket.storage-bucket.name}"
  predefined_acl = "publicreadwrite"
}
