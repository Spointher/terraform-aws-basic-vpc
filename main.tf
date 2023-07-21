locals {
  basic_security_groups = [
    {
      name          = "icmp"
      description   = "Allow incoming ICMP requests (Ping)"
      ingress_rules = [
        {
          description = "icmp-ingress"
          from_port   = -1
          to_port     = -1
          protocol    = "icmp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          description = "all-egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      name          = "web"
      description   = "Allow incoming HTTP and HTTPS requests"
      ingress_rules = [
        {
          description = "http-ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "https-ingress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          description = "all-egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  ]
}
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_host_name
  tags                 = {
    Name = lower(var.vpc_name)
  }
}
resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  tags   = {
    Name = "eip-${lower(var.vpc_name)}"
  }
  #DependsOn
  depends_on = [aws_vpc.vpc]
}
resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[count.index]
  tags              = merge(
    {
      Name = "private-subnet-${count.index + 1}-${var.availability_zones[count.index]}"
    },
    var.enable_eks_subnet_tags ? {
      "kubernetes.io/role/internal-elb" = "1"
    } : {}
  )
  #DependsOn
  depends_on = [aws_vpc.vpc]
}
resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[count.index]
  tags              = merge(
    {
      Name = "public-subnet-${count.index + 1}-${var.availability_zones[count.index]}"
    },
    var.enable_eks_subnet_tags ? {
      "kubernetes.io/role/elb" = "1"
    } : {}
  )
  map_public_ip_on_launch = true
  #DependsOn
  depends_on              = [aws_vpc.vpc]
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${lower(var.vpc_name)}-internet-gateway"
  }
  #DependsOn
  depends_on = [aws_vpc.vpc]
}
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.elastic_ip.id
  tags          = {
    Name = "${lower(var.vpc_name)}-nat-gateway"
  }
  #DependsOn
  depends_on = [aws_eip.elastic_ip, aws_subnet.public_subnets]
}
resource "aws_route_table" "private_route_table" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${lower(var.vpc_name)}-private-route-table-${count.index + 1}"
  }
  #DependsOn
  depends_on = [aws_vpc.vpc, aws_nat_gateway.nat_gateway]
}
resource "aws_route_table" "public_route_table" {
  count  = length(aws_subnet.public_subnets)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${lower(var.vpc_name)}-public-route-table-${count.index + 1}"
  }
  #DependsOn
  depends_on = [aws_vpc.vpc, aws_internet_gateway.internet_gateway]
}
resource "aws_route_table_association" "private_route_table_associations" {
  count          = length(aws_route_table.private_route_table)
  route_table_id = aws_route_table.private_route_table[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
  #DependsOn
  depends_on     = [aws_route_table.private_route_table, aws_subnet.private_subnets]
}
resource "aws_route_table_association" "public_route_table_associations" {
  count          = length(aws_route_table.public_route_table)
  route_table_id = aws_route_table.public_route_table[count.index].id
  subnet_id      = aws_subnet.public_subnets[count.index].id
  #DependsOn
  depends_on     = [aws_route_table.public_route_table, aws_subnet.public_subnets]
}
resource "aws_security_group" "security_groups" {
  count       = length(local.basic_security_groups)
  name        = "${local.basic_security_groups[count.index].name}-sg"
  description = local.basic_security_groups[count.index].description
  vpc_id      = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = local.basic_security_groups[count.index].ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.basic_security_groups[count.index].egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = "${local.basic_security_groups[count.index].name}-sg"
  }
  #DependsOn
  depends_on = [aws_vpc.vpc]
}