output "vpc_network" {
  description = "The URI of the created VPC network."
  value       = google_compute_network.vpc_network.self_link
}

output "vpc_network_name" {
  description = "The name of the compute instance."
  value       = google_compute_network.vpc_network.name
}

