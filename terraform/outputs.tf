output "service_url" {
  description = "The public URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.intens_api.status[0].url
}