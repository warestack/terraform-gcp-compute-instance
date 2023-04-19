resource "google_compute_instance" "instance" {
  name         = var.name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {}
  }

  tags = ["node-app", "flask-app", "http-server", "https-server"]

  metadata_startup_script = file("${path.module}/scripts/install-docker.sh")
}
