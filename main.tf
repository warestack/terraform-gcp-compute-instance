module "vpc" {
  source  = "./modules/vpc"
  name    = "${var.name}-vpc"
  project = var.project_id
}

module "compute-engine" {
  source  = "./modules/compute-engine"
  name    = "${var.name}-instance"
  network = module.vpc.vpc_network
}
