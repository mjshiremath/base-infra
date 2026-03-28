# Network Module

This Terraform module creates a comprehensive VPC (Virtual Private Cloud) infrastructure with public and private subnets, NAT gateways, internet gateways, and optional database subnets.

## Features

- **VPC**: Customizable VPC with DNS support
- **Public Subnets**: Subnets with internet access via Internet Gateway
- **Private Subnets**: Subnets with internet access via NAT Gateway
- **Database Subnets**: Optional isolated subnets for database resources
- **Internet Gateway**: Provides internet access for public subnets
- **NAT Gateways**: Provides internet access for private subnets
- **Route Tables**: Proper routing configuration for all subnet types
- **Security Groups**: Default security group with basic rules
- **Flow Logs**: Optional VPC flow logging for monitoring
- **Tags**: Comprehensive tagging support

## Usage

### Basic VPC with Public and Private Subnets

```hcl
module "network" {
  source = "./modules/network"

  vpc_name = "my-vpc"
  vpc_cidr_block = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### VPC with Database Subnets

```hcl
module "network" {
  source = "./modules/network"

  vpc_name = "my-vpc"
  vpc_cidr_block = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  
  # Enable database subnets
  create_database_subnets = true
  database_subnet_cidr_blocks = ["10.0.5.0/24", "10.0.6.0/24"]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### VPC without NAT Gateways (Cost Optimization)

```hcl
module "network" {
  source = "./modules/network"

  vpc_name = "my-vpc"
  vpc_cidr_block = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  
  # Disable NAT gateways to save costs
  create_nat_gateway = false

  tags = {
    Environment = "development"
    Project     = "my-project"
  }
}
```

### VPC with Flow Logs

```hcl
module "network" {
  source = "./modules/network"

  vpc_name = "my-vpc"
  vpc_cidr_block = "10.0.0.0/16"
  
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  
  # Enable flow logs
  enable_flow_log = true
  flow_log_destination_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vpc/flow-logs"

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

### Required

| Name | Description | Type | Default |
|------|-------------|------|---------|
| availability_zones | List of availability zones | `list(string)` | `["us-east-1a", "us-east-1b"]` |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| vpc_name | Name of the VPC | `string` | `"main-vpc"` |
| vpc_cidr_block | CIDR block for the VPC | `string` | `"10.0.0.0/16"` |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` |
| create_public_subnets | Whether to create public subnets | `bool` | `true` |
| public_subnet_cidr_blocks | List of CIDR blocks for public subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` |
| map_public_ip_on_launch | Should be true if you want to auto-assign public IP on launch | `bool` | `true` |
| create_private_subnets | Whether to create private subnets | `bool` | `true` |
| private_subnet_cidr_blocks | List of CIDR blocks for private subnets | `list(string)` | `["10.0.3.0/24", "10.0.4.0/24"]` |
| create_database_subnets | Whether to create database subnets | `bool` | `false` |
| database_subnet_cidr_blocks | List of CIDR blocks for database subnets | `list(string)` | `["10.0.5.0/24", "10.0.6.0/24"]` |
| create_internet_gateway | Whether to create an Internet Gateway for the VPC | `bool` | `true` |
| create_nat_gateway | Whether to create NAT Gateways | `bool` | `true` |
| create_default_security_group | Whether to create a default security group | `bool` | `true` |
| enable_flow_log | Whether to enable VPC Flow Logs | `bool` | `false` |
| flow_log_destination_arn | The ARN of the destination for VPC Flow Logs | `string` | `""` |
| flow_log_destination_type | The type of the destination for VPC Flow Logs | `string` | `"cloud-watch-logs"` |
| flow_log_traffic_type | The type of traffic to capture for VPC Flow Logs | `string` | `"ALL"` |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| database_subnet_ids | List of IDs of database subnets |
| internet_gateway_id | The ID of the Internet Gateway |
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_public_ips | List of public Elastic IPs created for NAT Gateway |
| public_route_table_id | ID of public route table |
| private_route_table_ids | List of IDs of private route tables |
| database_route_table_ids | List of IDs of database route tables |
| default_security_group_id | The ID of the default security group |
| public_subnets | Map of public subnets with their details |
| private_subnets | Map of private subnets with their details |
| database_subnets | Map of database subnets with their details |
| nat_gateways | Map of NAT Gateways with their details |

## Network Architecture

The module creates a typical three-tier network architecture:

```
Internet
    │
    ▼
┌─────────────────┐
│ Internet Gateway│
└─────────────────┘
    │
    ▼
┌─────────────────┐    ┌─────────────────┐
│  Public Subnets │    │ Private Subnets │
│  (10.0.1.0/24)  │    │ (10.0.3.0/24)   │
│  (10.0.2.0/24)  │    │ (10.0.4.0/24)   │
└─────────────────┘    └─────────────────┘
    │                        │
    ▼                        ▼
┌─────────────────┐    ┌─────────────────┐
│   NAT Gateway   │    │ Database Subnets│
│                 │    │ (10.0.5.0/24)   │
└─────────────────┘    │ (10.0.6.0/24)   │
                       └─────────────────┘
```

## Cost Considerations

- **NAT Gateways**: Each NAT Gateway costs approximately $0.045 per hour plus data processing fees
- **Elastic IPs**: Free when attached to running instances, $0.01 per hour when unattached
- **Flow Logs**: Additional costs for CloudWatch Logs storage and processing

To reduce costs in development environments:
- Set `create_nat_gateway = false`
- Use only public subnets for development workloads
- Disable flow logs with `enable_flow_log = false`

## Examples

See the `examples/` directory for complete working examples.

## Notes

- The module automatically creates route tables and associations
- NAT Gateways are created in public subnets
- Private subnets route through NAT Gateways for internet access
- Database subnets are isolated and can be used for RDS, ElastiCache, etc.
- All resources are properly tagged for cost tracking and management

## License

This module is licensed under the MIT License. 