output "vpc_id" {
  value = aws_vpc.vpc-dev.id
}
output "pub_sub_ids" {
 value =   aws_subnet.vpc-dev-public-subnet.*.id
}
output "priv_sub_ids" {
  value = aws_subnet.vpc-dev-private-subnet.*.id
}
 output "aws_security_group_id" {
 value = aws_security_group.dev-vpc-sg.id
}

/*
# Argument Reference: Security Groups associated to EC2 Instance
output "ec2_security_groups" {
  description = "List Security Groups associated with EC2 Instance"
  value = aws_instance.my-ec2-vm.security_groups
}
*/