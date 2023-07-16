[![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-blueviolet)](https://registry.terraform.io/modules/Spointher/basic-vpc/aws/latest)
[![Latest Release](https://img.shields.io/github/v/release/Spointher/terraform-aws-basic-vpc)](https://github.com/Spointher/terraform-aws-basic-vpc/releases/latest)
[![License](https://img.shields.io/github/license/Spointher/terraform-aws-basic-vpc)](https://github.com/Spointher/terraform-aws-basic-vpc/blob/master/LICENSE)

# Terraform AWS VPC Module

This Terraform module allows you to create a customizable AWS VPC (Virtual Private Cloud) infrastructure in a simple and
efficient way.

## Features

- Easily create a VPC with public and private subnets.
- Customizable CIDR block for each subnet.
- Create basic security groups.

## Example

```hcl
module "basic-vpc" {
  source               = "Spointher/basic-vpc/aws"
  vpc_cidr_block       = "10.0.0.0/16"
  vpc_enable_host_name = true
  vpc_name             = "vpc-sandbox"
  availability_zones   = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
    "us-east-1f"
  ]
  private_subnet_cidr_blocks = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
  ]
  public_subnet_cidr_blocks = [
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]
}
```

## Contributing

Contributions, bug reports, and suggestions are welcome! If you encounter any issues or have ideas for improvements,
please open an issue or submit a pull request. Your contributions will help make this module even better.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
