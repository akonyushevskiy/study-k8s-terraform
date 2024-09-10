provider "google" {
  project = var.project_id
  region  = var.region
}

# Create VPC Network
resource "google_compute_network" "default" {
  name                    = "study-k8s-network"
  auto_create_subnetworks  = true
}

# Reserve a private IP range for VPC peering (NO NETWORK FIELD HERE)
resource "google_compute_global_address" "private_ip_address" {
  name          = "study-k8s-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default.self_link
}

# Establish VPC peering between your VPC and Google's Service Networking
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.default.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name               = "study-k8s-cluster"
  location           = var.region
  initial_node_count = 1

  deletion_protection = false

  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 16
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Cloud SQL (PostgreSQL)
resource "google_sql_database_instance" "postgres_instance" {
  name             = "study-k8s-db"
  database_version = "POSTGRES_16"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      private_network = google_compute_network.default.self_link
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "study-k8s-db" {
  name     = "study-k8s-db-instance"
  instance = google_sql_database_instance.postgres_instance.name
}

# Redis (Google Memorystore)
resource "google_redis_instance" "study-k8s-redis" {
  name           = "study-k8s-redis-instance"
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region
  location_id    = var.redis_location
}

# Create IAM Service Account for accessing Google Secret Manager
resource "google_service_account" "gke_service_account" {
  account_id   = "gke-secret-manager"
  display_name = "GKE Secret Manager Access"
}

# Grant Secret Access Permissions
resource "google_project_iam_binding" "secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.gke_service_account.email}",
  ]
}
