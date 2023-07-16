output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}
output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "The CIDR block of the VPC"
}
output "private_subnet_ids" {
  value       = [for subnet in aws_subnet.private_subnets : subnet.id]
  description = "The IDs of the private subnets"
}
output "public_subnet_ids" {
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
  description = "The IDs of the public subnets"
}
output "basic_security_group" {
  value       = {for security_group in aws_security_group.security_groups : security_group.name => security_group.id}
  description = "The IDs with names of the security groups"
}