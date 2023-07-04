/*
locals {
  pub_sub_ids  = aws_subnet.vpc-dev-public-subnet.*.id
  priv_sub_ids = aws_subnet.vpc-dev-private-subnet.*.id
  azs          = data.aws_availability_zones.az.names
}
*/