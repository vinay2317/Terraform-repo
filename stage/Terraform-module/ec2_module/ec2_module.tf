# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc-dev"
  }
}

# Resource 2 :  Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = "${var.ec2_ami_id}"
  instance_type          = "${var.ec2_instance_type}"
  key_name               = "terraform-key"
  count                  = "${var.ec2_instance_count}"
  subnet_id              = "${aws_subnet.vpc-dev-public-subnet-1.id}"
# vpc_security_group_ids = [aws_security_group.dev-vpc-sg.id]
  user_data            = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
  vpc_security_group_ids = ["${var.sg_id}"]
  tags = {
    "Name" = "myec2vm"
  }
}

# Resource-2: Create Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id                  = "${aws_vpc.vpc-dev.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
}

# Resource-4: Create Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
}

# Resource-5: Create Route in Route Table for Internet Access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = "${aws_route_table.vpc-dev-public-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc-dev-igw.id}"
}

# Resource-6: Associate the Route Table with the Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate" {
  route_table_id = "${aws_route_table.vpc-dev-public-route-table.id}"
  subnet_id      = "${aws_subnet.vpc-dev-public-subnet-1.id}"
}
