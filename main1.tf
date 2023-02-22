provider "google" {
  project = "gkejob-09"
  region  = "asia-south1"
  zone    = "asia-south1-c"
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"

  disable_on_destroy = true
}

resource "google_cloud_run_service" "run_service" {
  name     = "mywebapp"
  location = "asia-south1"
  template {
    spec {
      containers {
        image = "gcr.io/gkejob-09/myimage"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.run_service.location
  project     = google_cloud_run_service.run_service.project
  service     = google_cloud_run_service.run_service.name
  policy_data = data.google_iam_policy.noauth.policy_data
}


output "service_url" {
  value = google_cloud_run_service.run_service.status[0].url
}
