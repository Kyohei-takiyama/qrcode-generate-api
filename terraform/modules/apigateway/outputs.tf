output "api_gateway_domain_name" {
  value = "${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com"
}

output "api_gateway_domain_id" {
  value = aws_api_gateway_rest_api.api.id
}
