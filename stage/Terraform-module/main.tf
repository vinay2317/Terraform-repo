# Terraform Block
terraform {
  required_version = ">= 1.4.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

# Getting output from sg_module
module "ec2_module" {
  sg_id  = module.sg_module.sg_id_output
  source = "./ec2_module"
}
# Sending output to ec2_module 
module "sg_module" {
  source = "./sg_module"
}
