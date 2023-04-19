output "network" {
  description = "The name of the Virtual Private Network."
  value       = module.vpc.vpc_network_name
}

output "instance" {
  description = "The name of the compute instance."
  value       = module.compute-engine.instance_name
}
