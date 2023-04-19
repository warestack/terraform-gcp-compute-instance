variable "name" {
  description = "The name to be used for the compute instance."
  type        = string
}

variable "network" {
  description = "The URI of the VPC network to be used from the compute instance."
  type        = string
}

variable "machine_type" {
  description = "The machine type to be associated with the compute instance."
  type        = string
  default     = "n1-standard-1"
}

variable "image" {
  description = "The image to be used for creating the boot disk."
  type        = string
  default     = "ubuntu-1804-bionic-v20211115"
}
