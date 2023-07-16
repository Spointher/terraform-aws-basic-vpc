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