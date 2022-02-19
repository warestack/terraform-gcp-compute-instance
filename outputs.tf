output "network" {
    value = module.vpc.vpc_network_name
}

output "instance" {
    value = module.compute-engine.instance_name
}

