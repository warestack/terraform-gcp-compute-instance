variable "name" {
  type    = string
}

variable "network" {
  type    = string
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "image" {
  type    = string
  default = "ubuntu-1804-bionic-v20211115"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}
