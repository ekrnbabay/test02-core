provider "aws" {
  version    = "~> 2.21"
  
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

provider "template" {
 version = "~> 2.1"
}
 
terraform {
  backend "s3" {
    bucket = "terraformraullab"
    key    = "tera.Lab8_PRJ02_DEV"
    region = "us-east-2"
  }
}

