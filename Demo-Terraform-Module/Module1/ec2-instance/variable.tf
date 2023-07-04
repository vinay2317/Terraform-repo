variable "ec2_ami_id" {
  description = "AMI ID"
  type = string  
  default = "ami-06b09bfacae1453cb"
}
variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}
variable "ec2_instance_count" {
  description = "EC2 instance count value"
  type = number
  default = "1"
}

variable "subnet_id" {
  description = "subnet value"
  type = string
#  default = module.networking.pub_sub_ids[count.index].id
}

variable "vpc-ssh" {
 description = "details of VPC ssh" 
 type = string
}
variable "vpc-web" {
  description = "details of vpc web"
  type = string
}
/*
variable "aws_security_group_id" {
  description = "security group value"
}
 output "aws_security_group_id" {
 value = aws_security_group.dev-vpc-sg.id
}
*/