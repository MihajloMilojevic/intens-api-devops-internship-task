variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west3"
}

variable "image_tag" {
  description = "Docker image tag (commit SHA)"
  type        = string
  default     = "latest"
}