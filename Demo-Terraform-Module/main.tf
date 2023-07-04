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

# First Module vpc-networking
module "networking" {
  source = "./Module/networking"
}


# Second Module  ec2_module 
module "ec2-instance" {
  source    = "./Module1/ec2-instance"
  subnet_id = module.networking.pub_sub_ids[0]
  vpc-ssh   = module.networking.vpc-ssh
  vpc-web   = module.networking.vpc-web
  # aws_security_group_id =   module.networking.aws_security_group_id
  # aws_security_group_id =   module.networking.aws_security_group_id
  # aws_security_group_ids = [module.networking.vpc-ssh.id, module.networking.vpc-web.id]
}

