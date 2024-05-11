module "apigateway" {
  source = "../../modules/apigateway"

  env_prefix           = local.env_prefix
  service_name         = local.service_name
  lambda_function_name = module.lambda.lambda_function_name
  lambda_function_uri  = module.lambda.lambda_function_uri
}

module "lambda" {
  source = "../../modules/lambda"

  env_prefix   = local.env_prefix
  service_name = local.service_name
}
