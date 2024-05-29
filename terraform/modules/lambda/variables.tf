variable "env_prefix" {
  description = "Prefix for the environment"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "image_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
