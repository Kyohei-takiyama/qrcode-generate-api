terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #   backend "s3" {
  #     region         = "ap-northeast-1"
  #     bucket         = "takisuke-development-terraform-state"
  #     key            = "development/terraform.tfstate"
  #     dynamodb_table = "tfstate-lock"
  #   }
  # }

  # resource "aws_s3_bucket" "terraform_state" {
  #   bucket = "takisuke-development-terraform-state"
  #   lifecycle {
  #     prevent_destroy = true
  #   }
  # }

  # resource "aws_dynamodb_table" "terraform_state_lock" {
  #   name           = "tfstate-lock"
  #   read_capacity  = 1
  #   write_capacity = 1
  #   hash_key       = "LockID"

  #   attribute {
  #     name = "LockID"
  #     type = "S"
  #   }
}
