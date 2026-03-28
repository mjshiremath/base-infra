# EKS module configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/eks"
}

# Reference the network module outputs
dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id              = "vpc-placeholder"
    private_subnet_ids  = ["subnet-placeholder-1", "subnet-placeholder-2"]
    public_subnet_ids   = ["subnet-placeholder-3", "subnet-placeholder-4"]
  }
}

inputs = {
  cluster_name            = "fargate-demo-dev"
  kubernetes_version      = "1.34"
  subnet_ids              = dependency.network.outputs.private_subnet_ids
  endpoint_private_access = true
  endpoint_public_access  = true

  # Node Group Configuration
  create_node_group           = true
  node_group_name             = "system-node-group"
  node_group_subnet_ids       = dependency.network.outputs.private_subnet_ids
  node_group_desired_size     = 1
  node_group_min_size         = 1
  node_group_max_size         = 3
  node_group_instance_types   = ["t3.small"]
  node_group_labels = {
    "workload-type" = "system"
  }

  # Fargate Profile Configuration
  create_fargate_profile      = true
  fargate_profile_name        = "fp-default"
  fargate_profile_subnet_ids  = dependency.network.outputs.private_subnet_ids

  fargate_profile_selectors = [
    {
      namespace = "default"
    },
    {
      namespace = "kube-system"
    }
  ]

  # Add-ons
  enable_vpc_cni_addon       = true
  enable_coredns_addon       = true
  enable_kube_proxy_addon    = true
  enable_ebs_csi_driver_addon = false
}
