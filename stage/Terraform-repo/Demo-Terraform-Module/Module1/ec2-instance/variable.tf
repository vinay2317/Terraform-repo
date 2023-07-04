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

variable "aws_security_group_id" {
  description = "subnet value"
}
