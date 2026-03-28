module "network" {
  source = "./modules/network"

  vpc_name                   = var.vpc_name
  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  create_public_subnets      = true
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  map_public_ip_on_launch    = var.map_public_ip_on_launch
  create_private_subnets     = true
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  create_internet_gateway    = true
  create_nat_gateway         = var.create_nat_gateway
  enable_dns_hostnames       = var.enable_dns_hostnames
  enable_dns_support         = var.enable_dns_support
  create_default_security_group = true

  # Add Kubernetes-specific tags for load balancer discovery
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = var.common_tags
}