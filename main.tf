resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_host_name
  tags                 = {
    Name = var.vpc_name
  }
}