output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "postgres_instance_name" {
  value = google_sql_database_instance.postgres_instance.name
}

output "redis_instance_name" {
  value = google_redis_instance.study-k8s-redis.name
}
