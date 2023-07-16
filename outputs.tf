output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC - string"
}
output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "The CIDR block of the VPC - string"
}
output "list_private_subnet_ids" {
  value       = [for subnet in aws_subnet.private_subnets : subnet.id]
  description = "The IDs of the private subnets - list(string)"
}
output "list_public_subnet_ids" {
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
  description = "The IDs of the public subnets - list(string)"
}
output "map_basic_security_group" {
  value       = {for security_group in aws_security_group.security_groups : security_group.name => security_group.id}
  description = "The IDs with names of the security groups - map(string)"
}
output "map_private_subnets" {
  value       = {for subnet in aws_subnet.private_subnets : subnet.availability_zone => subnet.id}
  description = "The IDs of the private subnets - map(string)"
}
output "map_public_subnets" {
  value       = {for subnet in aws_subnet.private_subnets : subnet.availability_zone => subnet.id}
  description = "The IDs of the public subnets - map(string)"
}