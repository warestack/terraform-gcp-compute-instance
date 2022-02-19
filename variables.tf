variable "credentials" {
  type        = string
  description = "Location of the credentials keyfile."
  default     = "./credentials.json"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in."
}

variable "region" {
  type        = string
  description = "The region to host the cluster in."
}

variable "name" {
  type        = string
  description = "The name of the env/workspace."
}
