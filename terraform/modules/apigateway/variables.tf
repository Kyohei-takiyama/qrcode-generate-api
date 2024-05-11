variable "env_prefix" {
  description = "Prefix for the environment"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "lambda_function_uri" {
  description = "URI of the lambda function"
  type        = string
}
