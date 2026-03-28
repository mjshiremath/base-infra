variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Network Module Variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "eks-fargate-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create NAT gateway for private subnets"
  type        = bool
  default     = true
}

# EKS Module Variables
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "fargate-demo"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "create_node_group" {
  description = "Whether to create an EKS node group (false for Fargate-only)"
  type        = bool
  default     = true
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "system-node-group"
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 3
}

variable "node_group_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_group_labels" {
  description = "Kubernetes labels for the node group"
  type        = map(string)
  default = {
    "workload-type" = "system"
  }
}

variable "create_fargate_profile" {
  description = "Whether to create a Fargate profile"
  type        = bool
  default     = true
}

variable "fargate_profile_name" {
  description = "Name of the Fargate profile"
  type        = string
  default     = "fp-default"
}

variable "enable_coredns_addon" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "coredns_addon_version" {
  description = "Version of CoreDNS addon"
  type        = string
  default     = "v1.12.1-eksbuild.2"
}

variable "enable_vpc_cni_addon" {
  description = "Enable VPC CNI addon"
  type        = bool
  default     = true
}

variable "enable_kube_proxy_addon" {
  description = "Enable kube-proxy addon"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}