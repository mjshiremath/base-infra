# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.main.default_security_group_id
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.main.default_network_acl_id
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.main.main_route_table_id
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = aws_vpc.main.ipv6_association_id
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = aws_vpc.main.ipv6_cidr_block
}

# Public Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_availability_zones" {
  description = "List of availability zones of public subnets"
  value       = aws_subnet.public[*].availability_zone
}

# Private Subnet Outputs
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_availability_zones" {
  description = "List of availability zones of private subnets"
  value       = aws_subnet.private[*].availability_zone
}

# Database Subnet Outputs
output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database[*].arn
}

output "database_subnet_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = aws_subnet.database[*].cidr_block
}

output "database_subnet_availability_zones" {
  description = "List of availability zones of database subnets"
  value       = aws_subnet.database[*].availability_zone
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = var.create_internet_gateway ? aws_internet_gateway.main[0].id : null
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = var.create_internet_gateway ? aws_internet_gateway.main[0].arn : null
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_arns" {
  description = "List of NAT Gateway ARNs"
  value       = []  # NAT Gateways don't have ARNs
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateway"
  value       = aws_eip.nat[*].public_ip
}

output "nat_private_ips" {
  description = "List of private Elastic IPs created for NAT Gateway"
  value       = aws_eip.nat[*].private_ip
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of public route table"
  value       = var.create_public_subnets ? aws_route_table.public[0].id : null
}

output "public_route_table_arn" {
  description = "ARN of public route table"
  value       = var.create_public_subnets ? aws_route_table.public[0].arn : null
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "private_route_table_arns" {
  description = "List of ARNs of private route tables"
  value       = aws_route_table.private[*].arn
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = aws_route_table.database[*].id
}

output "database_route_table_arns" {
  description = "List of ARNs of database route tables"
  value       = aws_route_table.database[*].arn
}

# Security Group Outputs
output "default_security_group_id" {
  description = "The ID of the default security group"
  value       = var.create_default_security_group ? aws_security_group.default[0].id : null
}

output "default_security_group_arn" {
  description = "The ARN of the default security group"
  value       = var.create_default_security_group ? aws_security_group.default[0].arn : null
}

# Flow Log Outputs
output "flow_log_id" {
  description = "The ID of the Flow Log"
  value       = var.enable_flow_log ? aws_flow_log.main[0].id : null
}

output "flow_log_arn" {
  description = "The ARN of the Flow Log"
  value       = var.enable_flow_log ? aws_flow_log.main[0].arn : null
}

# Combined Outputs
output "public_subnets" {
  description = "Map of public subnets with their details"
  value = {
    for i, subnet in aws_subnet.public : i => {
      id                = subnet.id
      arn               = subnet.arn
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
      name              = subnet.tags["Name"]
    }
  }
}

output "private_subnets" {
  description = "Map of private subnets with their details"
  value = {
    for i, subnet in aws_subnet.private : i => {
      id                = subnet.id
      arn               = subnet.arn
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
      name              = subnet.tags["Name"]
    }
  }
}

output "database_subnets" {
  description = "Map of database subnets with their details"
  value = {
    for i, subnet in aws_subnet.database : i => {
      id                = subnet.id
      arn               = subnet.arn
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
      name              = subnet.tags["Name"]
    }
  }
}

output "nat_gateways" {
  description = "Map of NAT Gateways with their details"
  value = {
    for i, nat in aws_nat_gateway.main : i => {
      id           = nat.id
      public_ip    = aws_eip.nat[i].public_ip
      private_ip   = aws_eip.nat[i].private_ip
      subnet_id    = nat.subnet_id
      name         = nat.tags["Name"]
    }
  }
} 