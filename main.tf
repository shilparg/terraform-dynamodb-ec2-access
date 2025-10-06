terraform {
  backend "s3" {
    bucket = "shilpakk-terraform-state"
    key    = "dynamodb-ec2-access/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "shilpakk-bookinventory"
}