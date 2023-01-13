terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.0"
    }
  }
}

variable "gcp_region" {
  type        = string
  description = "Region to use for GCP provider"
  default     = "europe-central2"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config"
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

resource "google_storage_bucket" "image-bucket" {
  name     = "image-bucket-test-8549-mk"
  location = "EU"
}

resource "google_storage_bucket_object" "archive" {
  name   = "test.zip"
  bucket = google_storage_bucket.image-bucket.name
  source = "./bin/test.zip"
}