output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}
output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "The CIDR block of the VPC"
}