# Resource 2 :  Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = "terraform-key"
  subnet_id              =  var.subnet_id
# vpc_security_group_ids = [var.aws_security_group_id]
  vpc_security_group_ids = [var.vpc-ssh, var.vpc-web]
  user_data              = file("apache-install.sh")
  tags = {
    "Name" = "my-ec2-vm"
  }
} 

   