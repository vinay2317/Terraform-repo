# Resource-1: Create VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block = "${var.vpc_cidr}"
  tags       = "${var.vpc_tags}"
  }


#Resource-1: Create Security Group
resource "aws_security_group" "dev-vpc-sg" {
  name        = "dev-vpc-sg"
  description = "Dev VPC Default Security Group"
  vpc_id      = "${aws_vpc.vpc-dev.id}"
    tags = {
      Name = "dev-vpc-sg"
  }

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow all IP and Ports Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Resource-2: Create public Subnets
resource "aws_subnet" "vpc-dev-public-subnet" {
  count                   = length(var.pub_cidrs)
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.pub_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc-dev-public-subnet-${count.index + 1}"
  }
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
  tags = {
    Name = "vpc-dev-igw"
  }
}

# Resource-4: Create Route Table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
  tags = {
    Name = "vpc-dev-public-route-table"
  }
}

# Resource-5: Create Route in Route Table for Internet Access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = "${aws_route_table.vpc-dev-public-route-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc-dev-igw.id}"
}

# Resource-6: Associate the Route Table with the Subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-associate" {
  count          = length(var.pub_cidrs)
  route_table_id =  aws_route_table.vpc-dev-public-route-table.id
  subnet_id      =  aws_subnet.vpc-dev-public-subnet.*.id[count.index]
}

# Resource-3: Create private Subnets
resource "aws_subnet" "vpc-dev-private-subnet" {
  count                   = length(var.pri_cidrs)
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = var.pri_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "vpc-dev-private-subnet-${count.index + 1}"
  }
}
