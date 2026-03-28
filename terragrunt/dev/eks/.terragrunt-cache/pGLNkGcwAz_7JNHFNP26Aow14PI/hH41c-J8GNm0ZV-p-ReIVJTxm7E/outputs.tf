output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_identity_providers" {
  description = "Map of identity providers for the cluster"
  value       = aws_eks_cluster.main.identity
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_platform_version" {
  description = "The platform version for the cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_status" {
  description = "The status of the EKS cluster"
  value       = aws_eks_cluster.main.status
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_vpc_config" {
  description = "The VPC configuration for the cluster"
  value       = aws_eks_cluster.main.vpc_config
}

# Node Group Outputs
output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].arn : null
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
  value       = var.create_node_group ? aws_eks_node_group.main[0].id : null
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources"
  value       = var.create_node_group ? aws_eks_node_group.main[0].resources : null
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = var.create_node_group ? aws_eks_node_group.main[0].status : null
}

# Fargate Profile Outputs
output "fargate_profile_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile"
  value       = var.create_fargate_profile ? aws_eks_fargate_profile.main[0].arn : null
}

output "fargate_profile_id" {
  description = "EKS Cluster name and EKS Fargate Profile name separated by a colon"
  value       = var.create_fargate_profile ? aws_eks_fargate_profile.main[0].id : null
}

output "fargate_profile_status" {
  description = "Status of the EKS Fargate Profile"
  value       = var.create_fargate_profile ? aws_eks_fargate_profile.main[0].status : null
}

# IAM Role Outputs
output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.eks_cluster_role.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_iam_role_name" {
  description = "IAM role name associated with EKS node group"
  value       = aws_iam_role.eks_node_group_role.name
}

output "node_group_iam_role_arn" {
  description = "IAM role ARN associated with EKS node group"
  value       = aws_iam_role.eks_node_group_role.arn
}

output "fargate_profile_iam_role_name" {
  description = "IAM role name associated with EKS Fargate profile"
  value       = var.create_fargate_profile ? aws_iam_role.eks_fargate_profile_role[0].name : null
}

output "fargate_profile_iam_role_arn" {
  description = "IAM role ARN associated with EKS Fargate profile"
  value       = var.create_fargate_profile ? aws_iam_role.eks_fargate_profile_role[0].arn : null
}

output "ebs_csi_driver_iam_role_arn" {
  description = "IAM role ARN associated with EBS CSI Driver add-on"
  value       = var.enable_ebs_csi_driver_addon ? aws_iam_role.eks_ebs_csi_driver_role[0].arn : null
}

# Add-on Outputs
output "vpc_cni_addon_arn" {
  description = "Amazon Resource Name (ARN) of the VPC CNI add-on"
  value       = var.enable_vpc_cni_addon ? aws_eks_addon.vpc_cni[0].arn : null
}

output "coredns_addon_arn" {
  description = "Amazon Resource Name (ARN) of the CoreDNS add-on"
  value       = var.enable_coredns_addon ? aws_eks_addon.coredns[0].arn : null
}

output "kube_proxy_addon_arn" {
  description = "Amazon Resource Name (ARN) of the kube-proxy add-on"
  value       = var.enable_kube_proxy_addon ? aws_eks_addon.kube_proxy[0].arn : null
}

output "ebs_csi_driver_addon_arn" {
  description = "Amazon Resource Name (ARN) of the EBS CSI Driver add-on"
  value       = var.enable_ebs_csi_driver_addon ? aws_eks_addon.aws_ebs_csi_driver[0].arn : null
}

# Data source for current region
data "aws_region" "current" {}

# Kubeconfig Output
output "kubeconfig" {
  description = "Kubeconfig file content for the EKS cluster"
  value = yamlencode({
    apiVersion = "v1"
    kind       = "Config"
    clusters = [
      {
        name = aws_eks_cluster.main.name
        cluster = {
          certificate-authority-data = aws_eks_cluster.main.certificate_authority[0].data
          server                     = aws_eks_cluster.main.endpoint
        }
      }
    ]
    contexts = [
      {
        name = aws_eks_cluster.main.name
        context = {
          cluster = aws_eks_cluster.main.name
          user    = aws_eks_cluster.main.name
        }
      }
    ]
    users = [
      {
        name = aws_eks_cluster.main.name
        user = {
          exec = {
            apiVersion = "client.authentication.k8s.io/v1beta1"
            command    = "aws"
            args = [
              "eks",
              "get-token",
              "--cluster-name",
              aws_eks_cluster.main.name,
              "--region",
              data.aws_region.current.id
            ]
          }
        }
      }
    ]
  })
  sensitive = true
} 