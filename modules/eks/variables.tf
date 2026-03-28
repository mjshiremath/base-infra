variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Node Group Variables
variable "create_node_group" {
  description = "Whether to create an EKS node group"
  type        = bool
  default     = true
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "default-node-group"
}

variable "node_group_subnet_ids" {
  description = "List of subnet IDs for the EKS node group"
  type        = list(string)
  default     = []
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_remote_access_enabled" {
  description = "Whether to enable remote access to the EKS node group"
  type        = bool
  default     = false
}

variable "node_group_ssh_key_name" {
  description = "SSH key name for remote access to the EKS node group"
  type        = string
  default     = null
}

variable "node_group_remote_access_security_group_ids" {
  description = "List of security group IDs for remote access to the EKS node group"
  type        = list(string)
  default     = []
}

variable "node_group_taints" {
  description = "List of taints to apply to the EKS node group"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "node_group_labels" {
  description = "Map of labels to apply to the EKS node group"
  type        = map(string)
  default     = {}
}

# Fargate Profile Variables
variable "create_fargate_profile" {
  description = "Whether to create an EKS Fargate profile"
  type        = bool
  default     = false
}

variable "fargate_profile_name" {
  description = "Name of the EKS Fargate profile"
  type        = string
  default     = "default-fargate-profile"
}

variable "fargate_profile_subnet_ids" {
  description = "List of subnet IDs for the EKS Fargate profile"
  type        = list(string)
  default     = []
}

variable "fargate_profile_selectors" {
  description = "List of selectors for the EKS Fargate profile"
  type = list(object({
    namespace = string
    labels    = optional(map(string))
  }))
  default = []
}

# Add-on Variables
variable "enable_vpc_cni_addon" {
  description = "Whether to enable the VPC CNI add-on"
  type        = bool
  default     = true
}

variable "vpc_cni_addon_version" {
  description = "Version of the VPC CNI add-on"
  type        = string
  default     = "v1.18.0-eksbuild.1"
}

variable "enable_coredns_addon" {
  description = "Whether to enable the CoreDNS add-on"
  type        = bool
  default     = true
}

variable "coredns_addon_version" {
  description = "Version of the CoreDNS add-on"
  type        = string
  default     = "v1.10.1-eksbuild.1"
}

variable "enable_kube_proxy_addon" {
  description = "Whether to enable the kube-proxy add-on"
  type        = bool
  default     = true
}

variable "kube_proxy_addon_version" {
  description = "Version of the kube-proxy add-on"
  type        = string
  default     = "v1.33.0-eksbuild.1"
}

variable "enable_ebs_csi_driver_addon" {
  description = "Whether to enable the EBS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "ebs_csi_driver_addon_version" {
  description = "Version of the EBS CSI Driver add-on"
  type        = string
  default     = "v2.20.0-eksbuild.1"
} 