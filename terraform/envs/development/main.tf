module "apigateway" {
  source = "../../modules/apigateway"

  env_prefix              = local.env_prefix
  service_name            = local.service_name
  lambda_function_name    = module.lambda.lambda_function_name
  lambda_function_uri     = module.lambda.lambda_function_uri
  region                  = local.aws_region
  api_gateway_domain_name = var.domain_name
  certificate_arn         = module.cloudfront.certificate_arn
}

module "lambda" {
  source = "../../modules/lambda"

  env_prefix      = local.env_prefix
  service_name    = local.service_name
  image_repo_name = local.image_repo_name
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  api_gateway_domain_name = module.apigateway.api_gateway_domain_name
  api_gateway_domain_id   = module.apigateway.api_gateway_domain_id
  domain_name             = var.domain_name
  host_domain_name        = var.host_domain_name
  aws_region              = local.aws_region
}
