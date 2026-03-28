# Network module configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/network"
}

inputs = {
  vpc_name                   = "eks-fargate-vpc-dev"
  vpc_cidr_block             = "172.16.0.0/16"
  availability_zones         = ["us-east-1a", "us-east-1b"]
  create_public_subnets      = true
  public_subnet_cidr_blocks  = ["172.16.0.0/24", "172.16.1.0/24"]
  map_public_ip_on_launch    = true
  create_private_subnets     = true
  private_subnet_cidr_blocks = ["172.16.10.0/24", "172.16.11.0/24"]
  create_internet_gateway    = true
  create_nat_gateway         = true
  enable_dns_hostnames       = true
  enable_dns_support         = true
  create_default_security_group = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
