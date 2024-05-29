locals {
  stage_name      = "dev"
  env_prefix      = "dev"
  service_name    = "qrcode-generator"
  resource_prefix = "${local.env_prefix}-${local.service_name}"
  aws_region      = "ap-northeast-1"
  image_repo_name = "${local.env_prefix}-${local.service_name}-${local.stage_name}"
}
