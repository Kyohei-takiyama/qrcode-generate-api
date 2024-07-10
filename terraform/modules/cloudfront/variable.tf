variable "domain_name" {
  description = "The domain name of the CloudFront"
  type        = string
}

variable "host_domain_name" {
  description = "The host domain name"
  type        = string
}

variable "api_gateway_domain_name" {
  description = "The domain name of the API Gateway"
  type        = string
}

variable "api_gateway_domain_id" {
  type = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}
