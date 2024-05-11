provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Product    = "qrcode-generator"
      Service    = local.service_name
      Env        = local.env_prefix
      Created    = "terraform"
      Repository = "qrcode-generate-api"
      Billing    = local.service_name
    }
  }
}
