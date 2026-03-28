# EKS Module

This Terraform module creates an Amazon EKS (Elastic Kubernetes Service) cluster with optional node groups, Fargate profiles, and add-ons.

## Features

- **EKS Cluster**: Creates a managed Kubernetes cluster
- **Node Groups**: Optional managed node groups for worker nodes
- **Fargate Profiles**: Optional Fargate profiles for serverless pod execution
- **Add-ons**: Support for essential EKS add-ons (VPC CNI, CoreDNS, kube-proxy, EBS CSI Driver)
- **IAM Roles**: Proper IAM roles and policies for cluster, node groups, and add-ons
- **Security**: Configurable endpoint access and security groups

## Usage

### Basic EKS Cluster

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name = "my-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### EKS Cluster with Node Group

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name = "my-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Node Group Configuration
  create_node_group = true
  node_group_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  node_group_desired_size = 2
  node_group_max_size     = 4
  node_group_min_size     = 1
  node_group_instance_types = ["t3.medium", "t3.large"]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### EKS Cluster with Fargate Profile

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name = "my-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Fargate Profile Configuration
  create_fargate_profile = true
  fargate_profile_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  fargate_profile_selectors = [
    {
      namespace = "default"
    },
    {
      namespace = "kube-system"
    }
  ]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### EKS Cluster with All Add-ons

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name = "my-eks-cluster"
  subnet_ids   = ["subnet-12345678", "subnet-87654321"]
  
  # Enable all add-ons
  enable_vpc_cni_addon = true
  enable_coredns_addon = true
  enable_kube_proxy_addon = true
  enable_ebs_csi_driver_addon = true

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
| cluster_name | Name of the EKS cluster | `string` | n/a |
| subnet_ids | List of subnet IDs for the EKS cluster | `list(string)` | n/a |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| kubernetes_version | Kubernetes version for the EKS cluster | `string` | `"1.28"` |
| endpoint_private_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` |
| endpoint_public_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `true` |
| cluster_security_group_ids | List of security group IDs for the EKS cluster | `list(string)` | `[]` |
| enabled_cluster_log_types | List of the desired control plane logging to enable | `list(string)` | `["api", "audit", "authenticator", "controllerManager", "scheduler"]` |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` |

### Node Group Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_node_group | Whether to create an EKS node group | `bool` | `true` |
| node_group_name | Name of the EKS node group | `string` | `"default-node-group"` |
| node_group_subnet_ids | List of subnet IDs for the EKS node group | `list(string)` | `[]` |
| node_group_desired_size | Desired number of worker nodes | `number` | `2` |
| node_group_max_size | Maximum number of worker nodes | `number` | `4` |
| node_group_min_size | Minimum number of worker nodes | `number` | `1` |
| node_group_instance_types | List of instance types for the EKS node group | `list(string)` | `["t3.medium"]` |

### Fargate Profile Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_fargate_profile | Whether to create an EKS Fargate profile | `bool` | `false` |
| fargate_profile_name | Name of the EKS Fargate profile | `string` | `"default-fargate-profile"` |
| fargate_profile_subnet_ids | List of subnet IDs for the EKS Fargate profile | `list(string)` | `[]` |
| fargate_profile_selectors | List of selectors for the EKS Fargate profile | `list(object({namespace = string, labels = optional(map(string))}))` | `[]` |

### Add-on Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| enable_vpc_cni_addon | Whether to enable the VPC CNI add-on | `bool` | `true` |
| enable_coredns_addon | Whether to enable the CoreDNS add-on | `bool` | `true` |
| enable_kube_proxy_addon | Whether to enable the kube-proxy add-on | `bool` | `true` |
| enable_ebs_csi_driver_addon | Whether to enable the EBS CSI Driver add-on | `bool` | `false` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_arn | The Amazon Resource Name (ARN) of the cluster |
| cluster_endpoint | The endpoint for the EKS cluster |
| cluster_name | The name of the EKS cluster |
| cluster_oidc_issuer_url | The URL on the EKS cluster for the OpenID Connect identity provider |
| cluster_status | The status of the EKS cluster |
| cluster_version | The Kubernetes version for the cluster |
| node_group_arn | Amazon Resource Name (ARN) of the EKS Node Group |
| node_group_status | Status of the EKS Node Group |
| fargate_profile_arn | Amazon Resource Name (ARN) of the EKS Fargate Profile |
| fargate_profile_status | Status of the EKS Fargate Profile |
| cluster_iam_role_arn | IAM role ARN associated with EKS cluster |
| node_group_iam_role_arn | IAM role ARN associated with EKS node group |
| kubeconfig | Kubeconfig file content for the EKS cluster (sensitive) |

## Examples

See the `examples/` directory for complete working examples.

## Notes

- The module creates necessary IAM roles and policies for EKS cluster, node groups, and add-ons
- OIDC provider is automatically configured for the cluster
- The module supports both EC2 node groups and Fargate profiles
- Add-ons are optional and can be enabled/disabled as needed
- The kubeconfig output is marked as sensitive and should be handled carefully

## License

This module is licensed under the MIT License. 