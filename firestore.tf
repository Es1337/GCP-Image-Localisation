resource "google_app_engine_application" "user-db" {
  project     = var.gcp_project
  location_id = var.gcp_region
  database_type = "CLOUD_FIRESTORE"
}