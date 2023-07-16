# Changelog

## Release [v1.0.1](https://github.com/Spointher/terraform-aws-basic-vpc/releases/tag/v1.0.1)

### Features

- Added new output variables

```hcl
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
```

- Deleted older output variables

```hcl
output "private_subnet_ids" {}
output "public_subnet_ids" {}
```

- Added into the description of each output variable the data type

## Release [v1.0.0](https://github.com/Spointher/terraform-aws-basic-vpc/releases/tag/v1.0.0)

### Features

- Added the CHANGELOG.md file.
- Improved the README.md file.

## Release [v0.0.2](https://github.com/Spointher/terraform-aws-basic-vpc/releases/tag/v0.0.2)

### Features

- Creation of public and private subnets.
- Creation of internet gateway and nat gateway.
- Creation of routing tables for each subnet.

## Release [v0.0.1](https://github.com/Spointher/terraform-aws-basic-vpc/releases/tag/v0.0.1)

### Features

- Added only VPC creation feature.
