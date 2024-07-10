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

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "api_gateway_domain_name" {
  description = "The domain name of the API Gateway"
  type        = string
}

variable "certificate_arn" {
  type = string
}
