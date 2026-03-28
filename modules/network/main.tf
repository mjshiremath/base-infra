# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = var.create_public_subnets ? length(var.public_subnet_cidr_blocks) : 0

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
      Tier = "Public"
    },
    var.public_subnet_tags,
    var.tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = var.create_private_subnets ? length(var.private_subnet_cidr_blocks) : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
      Tier = "Private"
    },
    var.private_subnet_tags,
    var.tags
  )
}

# Database Subnets (if enabled)
resource "aws_subnet" "database" {
  count = var.create_database_subnets ? length(var.database_subnet_cidr_blocks) : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.vpc_name}-database-${var.availability_zones[count.index]}"
      Tier = "Database"
    },
    var.database_subnet_tags,
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count = var.create_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.tags
  )
}

# NAT Gateway EIP
resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? length(var.public_subnet_cidr_blocks) : 0

  domain = "vpc"

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  count = var.create_nat_gateway ? length(var.public_subnet_cidr_blocks) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-${count.index + 1}"
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.main]
}

# Public Route Table
resource "aws_route_table" "public" {
  count = var.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_internet_gateway ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main[0].id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-public-rt"
    },
    var.tags
  )
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.create_private_subnets ? length(var.private_subnet_cidr_blocks) : 0

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    },
    var.tags
  )
}

# Database Route Tables
resource "aws_route_table" "database" {
  count = var.create_database_subnets ? length(var.database_subnet_cidr_blocks) : 0

  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[count.index % length(aws_nat_gateway.main)].id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-database-rt-${count.index + 1}"
    },
    var.tags
  )
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = var.create_public_subnets ? length(var.public_subnet_cidr_blocks) : 0

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = var.create_private_subnets ? length(var.private_subnet_cidr_blocks) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Database Route Table Associations
resource "aws_route_table_association" "database" {
  count = var.create_database_subnets ? length(var.database_subnet_cidr_blocks) : 0

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# Default Security Group
resource "aws_security_group" "default" {
  count = var.create_default_security_group ? 1 : 0

  name_prefix = "${var.vpc_name}-default-"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-default-sg"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Flow Logs
resource "aws_flow_log" "main" {
  count = var.enable_flow_log ? 1 : 0

  log_destination      = var.flow_log_destination_arn
  log_destination_type = var.flow_log_destination_type
  traffic_type         = var.flow_log_traffic_type
  vpc_id               = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.vpc_name}-flow-log"
    },
    var.tags
  )
} 