terraform {
  backend "s3" {
    bucket         = "redmine-aws-tfstate"
    key            = "redmine-aws.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "redmine-aws-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    MannagedBy  = "Terraform"
  }
  # Network part for VPC cidr block (set this to avoid conflicts)
  vpc_cidr_network = "30.30"
}

# Retrieve current region to avoid hard coding
data "aws_region" "current" {}
