resource "google_compute_network" "vpc_network" {
  name                    = var.name
  project                 = var.project
  auto_create_subnetworks = true
}
