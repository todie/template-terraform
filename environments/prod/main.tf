terraform {
  required_version = ">= 1.6"

  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

module "root" {
  source = "../.."

  project_name = "my-project"
  environment  = "prod"
  aws_region   = "us-east-1"
}
