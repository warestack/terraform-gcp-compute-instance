output "vpc_network" {
  value = google_compute_network.vpc_network.self_link
}

output "vpc_network_name" {
  value = google_compute_network.vpc_network.name
}

