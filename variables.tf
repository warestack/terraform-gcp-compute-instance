variable "credentials" {
  description = "Location of the credentials keyfile."
  type        = string
  default     = "./credentials.json"
}

variable "project_id" {
  description = "The project ID to host the instance in."
  type        = string
}

variable "region" {
  description = "The region to host the instance in."
  type        = string
}

variable "zone" {
  description = "The zone to host the instance in."
  type        = string
}

variable "name" {
  description = "The name of the env/workspace."
  type        = string
}
