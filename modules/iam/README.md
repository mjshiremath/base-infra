# IAM Module

This Terraform module creates IAM roles, policies, and ECR repositories for containerized applications and AWS services.

## Features

- **ECR Repository**: Container image repository with scanning and lifecycle policies
- **ECR Push Role**: IAM role for pushing images to ECR
- **ECR Pull Role**: IAM role for pulling images from ECR
- **Application Role**: General-purpose role for application services
- **Lambda Execution Role**: Role for Lambda function execution
- **Custom Roles**: Flexible custom role creation with policies
- **Repository Policies**: Configurable ECR repository access policies
- **Lifecycle Policies**: Image cleanup and retention policies

## Usage

### Basic ECR Setup

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  ecr_push_role_name  = "my-app-ecr-push-role"

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### ECR with Pull Role

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  ecr_push_role_name  = "my-app-ecr-push-role"
  
  # Enable pull role for read-only access
  create_ecr_pull_role = true
  ecr_pull_role_name   = "my-app-ecr-pull-role"

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Application Role with Custom Policy

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  ecr_push_role_name  = "my-app-ecr-push-role"
  
  # Create application role
  create_application_role = true
  application_role_name   = "my-app-role"
  application_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::my-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Lambda Execution Role

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  
  # Create Lambda execution role
  create_lambda_execution_role = true
  lambda_execution_role_name   = "my-lambda-role"
  lambda_execution_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Custom Roles

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  
  # Create custom roles
  custom_roles = {
    backup_role = {
      name        = "backup-role"
      description = "Role for backup operations"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          }
        ]
      })
    }
  }

  custom_role_policy_attachments = [
    {
      role_name  = "backup_role"
      policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    }
  ]

  custom_role_policies = {
    backup_policy = {
      name      = "backup-policy"
      role_name = "backup_role"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject"
            ]
            Resource = "arn:aws:s3:::backup-bucket/*"
          }
        ]
      })
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### ECR with Repository Policy

```hcl
module "iam" {
  source = "./modules/iam"

  ecr_repository_name = "my-app-repo"
  ecr_push_role_name  = "my-app-ecr-push-role"
  
  # Custom repository policy
  ecr_repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })

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

### ECR Repository

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_ecr_repository | Whether to create an ECR repository | `bool` | `true` |
| ecr_repository_name | Name of the ECR repository | `string` | `"app-image-repo"` |
| ecr_image_tag_mutability | The tag mutability setting for the repository | `string` | `"MUTABLE"` |
| ecr_scan_on_push | Indicates whether images are scanned after being pushed | `bool` | `true` |
| ecr_encryption_type | The encryption type for the repository | `string` | `"AES256"` |
| ecr_repository_policy | The policy to be applied to the repository | `string` | `null` |
| ecr_lifecycle_policy | The lifecycle policy to be applied to the repository | `string` | `null` |

### ECR Push Role

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_ecr_push_role | Whether to create an ECR push role | `bool` | `true` |
| ecr_push_role_name | Name of the ECR push role | `string` | `"ecr-push-role"` |
| ecr_push_role_description | Description of the ECR push role | `string` | `"IAM role for pushing images to ECR"` |
| ecr_push_role_trusted_entities | Additional trusted entities for the ECR push role | `list(object)` | `[]` |

### ECR Pull Role

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_ecr_pull_role | Whether to create an ECR pull role | `bool` | `false` |
| ecr_pull_role_name | Name of the ECR pull role | `string` | `"ecr-pull-role"` |
| ecr_pull_role_description | Description of the ECR pull role | `string` | `"IAM role for pulling images from ECR"` |
| ecr_pull_role_trusted_entities | Additional trusted entities for the ECR pull role | `list(object)` | `[]` |

### Application Role

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_application_role | Whether to create an application role | `bool` | `false` |
| application_role_name | Name of the application role | `string` | `"application-role"` |
| application_role_description | Description of the application role | `string` | `"IAM role for application services"` |
| application_role_trusted_entities | Trusted entities for the application role | `list(object)` | `[]` |
| application_role_policy | Custom policy for the application role | `string` | `null` |
| application_role_policy_arns | List of policy ARNs to attach to the application role | `list(string)` | `[]` |

### Lambda Execution Role

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_lambda_execution_role | Whether to create a Lambda execution role | `bool` | `false` |
| lambda_execution_role_name | Name of the Lambda execution role | `string` | `"lambda-execution-role"` |
| lambda_execution_role_description | Description of the Lambda execution role | `string` | `"IAM role for Lambda function execution"` |
| lambda_execution_role_trusted_entities | Additional trusted entities for the Lambda execution role | `list(object)` | `[]` |
| lambda_execution_role_policy_arns | List of policy ARNs to attach to the Lambda execution role | `list(string)` | `["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]` |

### Custom Roles

| Name | Description | Type | Default |
|------|-------------|------|---------|
| custom_roles | Map of custom IAM roles to create | `map(object)` | `{}` |
| custom_role_policy_attachments | List of custom role policy attachments | `list(object)` | `[]` |
| custom_role_policies | Map of custom role policies to create | `map(object)` | `{}` |

### General

| Name | Description | Type | Default |
|------|-------------|------|---------|
| iam_role_path | Path for IAM roles | `string` | `"/"` |
| iam_role_max_session_duration | Maximum session duration in seconds for IAM roles | `number` | `3600` |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| ecr_repository_url | The URL of the ECR repository |
| ecr_repository_arn | The ARN of the ECR repository |
| ecr_push_role_arn | The ARN of the ECR push role |
| ecr_pull_role_arn | The ARN of the ECR pull role |
| application_role_arn | The ARN of the application role |
| lambda_execution_role_arn | The ARN of the Lambda execution role |
| custom_role_arns | Map of custom role ARNs |
| all_role_arns | Map of all created role ARNs |
| all_role_names | Map of all created role names |

## Security Best Practices

- **Principle of Least Privilege**: Only grant necessary permissions
- **Role-based Access**: Use roles instead of access keys when possible
- **Cross-account Access**: Use conditions in trust policies for cross-account access
- **Regular Rotation**: Implement regular credential rotation
- **Monitoring**: Enable CloudTrail for IAM activity monitoring

## Examples

See the `examples/` directory for complete working examples.

## Notes

- ECR repositories are created with image scanning enabled by default
- Default ECR push role uses `AmazonEC2ContainerRegistryPowerUser` policy
- Default ECR pull role uses `AmazonEC2ContainerRegistryReadOnly` policy
- Lambda execution role includes basic execution policy by default
- All resources are properly tagged for cost tracking and management

## License

This module is licensed under the MIT License. 