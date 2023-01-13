resource "google_cloudfunctions_function" "process-image" {
  name        = "process-image"
  description = "Processes image added to Cloud Storage"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.image-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
#   trigger_http          = true
  entry_point           = "process_new_image"

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource = "${google_storage_bucket.image-bucket.name}"
  }
}

resource "google_cloudfunctions_function" "save-user" {
  name        = "save-user"
  description = "Save user to Firestore"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.image-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "save_user"
}

resource "google_cloudfunctions_function" "get-result" {
  name        = "get-result"
  description = "Get processing result from Firestore"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.image-bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "get_result"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker-process-image" {
  project        = google_cloudfunctions_function.process-image.project
  region         = google_cloudfunctions_function.process-image.region
  cloud_function = google_cloudfunctions_function.process-image.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "invoker-save-user" {
  project        = google_cloudfunctions_function.save-user.project
  region         = google_cloudfunctions_function.save-user.region
  cloud_function = google_cloudfunctions_function.save-user.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "invoker-get-result" {
  project        = google_cloudfunctions_function.get-result.project
  region         = google_cloudfunctions_function.get-result.region
  cloud_function = google_cloudfunctions_function.get-result.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}