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

# resource "google_project_service" "service" {
#   for_each = toset([
#     "storage.googleapis.com",
#     "cloudfunctions.googleapis.com"
#   ])
#
#   service = each.key
#
#   project            = google.project.project_id
#   disable_on_destroy = false
# }

resource "google_storage_bucket" "image-bucket" {
  name     = "image-bucket-test-8549-mk"
  location = "EU"
}

resource "google_storage_bucket_object" "archive" {
  name   = "test.zip"
  bucket = google_storage_bucket.image-bucket.name
  source = "./bin/test.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "Function test"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.image-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "save_blob"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}