module "eks" {
  source = "./modules/eks"

  cluster_name                = var.cluster_name
  kubernetes_version          = var.kubernetes_version
  subnet_ids                  = module.network.private_subnet_ids
  endpoint_private_access     = true
  endpoint_public_access      = true
  create_node_group           = var.create_node_group
  node_group_name             = var.node_group_name
  node_group_subnet_ids       = module.network.private_subnet_ids
  node_group_desired_size     = var.node_group_desired_size
  node_group_min_size         = var.node_group_min_size
  node_group_max_size         = var.node_group_max_size
  node_group_instance_types   = var.node_group_instance_types
  node_group_labels           = var.node_group_labels
  create_fargate_profile      = var.create_fargate_profile
  fargate_profile_name        = var.fargate_profile_name
  fargate_profile_subnet_ids  = module.network.private_subnet_ids

  # Configure Fargate profile selectors for default and kube-system namespaces
  fargate_profile_selectors = [
    {
      namespace = "default"
    },
    {
      namespace = "kube-system"
    }
  ]

  # Enable addons
  enable_vpc_cni_addon       = var.enable_vpc_cni_addon
  enable_coredns_addon       = var.enable_coredns_addon
  coredns_addon_version      = var.coredns_addon_version
  enable_kube_proxy_addon    = var.enable_kube_proxy_addon
  enable_ebs_csi_driver_addon = false

  tags = var.common_tags

  depends_on = [module.network]
}