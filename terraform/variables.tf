variable "env_prefix" {
  description = "Prefix for the environment"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "qrcode-generator"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to use"
  type        = string
  default     = "ap-northeast-1"
}
