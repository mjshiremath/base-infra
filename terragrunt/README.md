# Terragrunt Configuration

This directory contains the Terragrunt configurations for managing EKS and networking infrastructure.

## Directory Structure

```
terragrunt/
├── terragrunt.hcl          # Root configuration (common settings)
└── dev/                    # Development environment
    ├── terragrunt.hcl      # Environment-specific config
    ├── network/            # Network module
    │   └── terragrunt.hcl
    └── eks/                # EKS module
        └── terragrunt.hcl
```

## Key Features

- **DRY Configuration**: Common settings defined once in root `terragrunt.hcl`
- **Module Dependencies**: EKS module depends on Network module outputs
- **State Management**: Local state stored at root level
- **Environment Isolation**: Separate configs for dev, staging, prod (easily scalable)
- **Automatic Backend Generation**: Backend configuration auto-generated

## Usage

### Prerequisites

```bash
# Install terragrunt (>= 0.63.0)
brew install terragrunt

# Or verify installation
terragrunt --version
```

### Plan All Resources

```bash
cd terragrunt/dev
terragrunt plan-all
```

### Apply All Resources

```bash
cd terragrunt/dev
terragrunt apply-all
```

### Destroy All Resources

```bash
cd terragrunt/dev
terragrunt destroy-all
```

### Manage Individual Modules

```bash
# Network only
cd terragrunt/dev/network
terragrunt plan
terragrunt apply
terragrunt destroy

# EKS only
cd terragrunt/dev/eks
terragrunt plan
terragrunt apply
terragrunt destroy
```

## Configuration Details

### Network Module (dev/network/terragrunt.hcl)
- **VPC CIDR**: 172.16.0.0/16
- **Public Subnets**: 172.16.0.0/24, 172.16.1.0/24 (us-east-1a, us-east-1b)
- **Private Subnets**: 172.16.10.0/24, 172.16.11.0/24 (us-east-1a, us-east-1b)
- **NAT Gateway**: Enabled for private subnet outbound traffic
- **DNS**: Enabled for both hostnames and support

### EKS Module (dev/eks/terragrunt.hcl)
- **Cluster Name**: fargate-demo-dev
- **Kubernetes Version**: 1.33
- **Node Group**: 1 desired, min 1, max 3 (t3.small)
- **Fargate Profile**: Enabled for default and kube-system namespaces
- **Add-ons**: VPC-CNI, CoreDNS, kube-proxy

## Add-on Versions

The add-on versions are now managed automatically by AWS EKS (no explicit version specified), ensuring compatibility with Kubernetes 1.33.

## Tags

All resources are tagged with:
- `Environment`: dev
- `ManagedBy`: Terraform
- `created_by`: 27925
- `ManagedWith`: Terragrunt

## Next Steps

1. Install terragrunt if not already installed
2. Navigate to `terragrunt/dev`
3. Run `terragrunt plan-all` to review changes
4. Run `terragrunt apply-all` to create resources

For more info: https://terragrunt.gruntwork.io/
