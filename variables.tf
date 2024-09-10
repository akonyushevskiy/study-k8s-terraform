variable "project_id" {
  description = "The Google Cloud project ID"
}

variable "region" {
  description = "The Google Cloud region"
  default     = "europe-west1"
}

variable "db_password" {
  description = "The PostgreSQL database password"
}

variable "redis_location" {
  description = "The Redis location"
  default     = "europe-west1-b"
}
