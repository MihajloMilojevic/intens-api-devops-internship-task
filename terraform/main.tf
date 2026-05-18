terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Store state in GCS instead of locally
  backend "gcs" {
    bucket = "intens-api-devops-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Artifact Registry repository to store Docker images
resource "google_artifact_registry_repository" "intens_api_repo" {
  location      = var.region
  repository_id = "intens-api"
  format        = "DOCKER"
}

# Cloud Run service — this is your running app
resource "google_cloud_run_service" "intens_api" {
  name     = "intens-api"
  location = var.region

  template {
    spec {
      containers {
        # This image path is built from your Artifact Registry repo
        image = "${var.region}-docker.pkg.dev/${var.project_id}/intens-api/intens-api:latest"

        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Make the Cloud Run service publicly accessible (no auth required)
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.intens_api.name
  location = google_cloud_run_service.intens_api.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}