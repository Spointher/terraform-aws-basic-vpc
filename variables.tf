variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}
variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}
variable "vpc_enable_host_name" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
}
variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to use for the VPC subnets"
}
variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the private subnets"
}
variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks for the public subnets"
}
variable "enable_eks_subnet_tags" {
  type        = bool
  description = "Enable tags for the EKS subnets (kubernetes.io/role/internal-elb / kubernetes.io/role/elb)"
  default     = false
}