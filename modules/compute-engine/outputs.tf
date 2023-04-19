output "instance_name" {
  description = "The name of the compute instance."
  value       = google_compute_instance.instance.name
}
