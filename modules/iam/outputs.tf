# ECR Repository Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = var.create_ecr_repository ? aws_ecr_repository.main[0].repository_url : null
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = var.create_ecr_repository ? aws_ecr_repository.main[0].arn : null
}

output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = var.create_ecr_repository ? aws_ecr_repository.main[0].name : null
}

output "ecr_repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = var.create_ecr_repository ? aws_ecr_repository.main[0].registry_id : null
}

# ECR Push Role Outputs
output "ecr_push_role_arn" {
  description = "The ARN of the ECR push role"
  value       = var.create_ecr_push_role ? aws_iam_role.ecr_push[0].arn : null
}

output "ecr_push_role_name" {
  description = "The name of the ECR push role"
  value       = var.create_ecr_push_role ? aws_iam_role.ecr_push[0].name : null
}

output "ecr_push_role_id" {
  description = "The ID of the ECR push role"
  value       = var.create_ecr_push_role ? aws_iam_role.ecr_push[0].id : null
}

# ECR Pull Role Outputs
output "ecr_pull_role_arn" {
  description = "The ARN of the ECR pull role"
  value       = var.create_ecr_pull_role ? aws_iam_role.ecr_pull[0].arn : null
}

output "ecr_pull_role_name" {
  description = "The name of the ECR pull role"
  value       = var.create_ecr_pull_role ? aws_iam_role.ecr_pull[0].name : null
}

output "ecr_pull_role_id" {
  description = "The ID of the ECR pull role"
  value       = var.create_ecr_pull_role ? aws_iam_role.ecr_pull[0].id : null
}

# Application Role Outputs
output "application_role_arn" {
  description = "The ARN of the application role"
  value       = var.create_application_role ? aws_iam_role.application[0].arn : null
}

output "application_role_name" {
  description = "The name of the application role"
  value       = var.create_application_role ? aws_iam_role.application[0].name : null
}

output "application_role_id" {
  description = "The ID of the application role"
  value       = var.create_application_role ? aws_iam_role.application[0].id : null
}

# Lambda Execution Role Outputs
output "lambda_execution_role_arn" {
  description = "The ARN of the Lambda execution role"
  value       = var.create_lambda_execution_role ? aws_iam_role.lambda_execution[0].arn : null
}

output "lambda_execution_role_name" {
  description = "The name of the Lambda execution role"
  value       = var.create_lambda_execution_role ? aws_iam_role.lambda_execution[0].name : null
}

output "lambda_execution_role_id" {
  description = "The ID of the Lambda execution role"
  value       = var.create_lambda_execution_role ? aws_iam_role.lambda_execution[0].id : null
}

# Custom Roles Outputs
output "custom_role_arns" {
  description = "Map of custom role ARNs"
  value = {
    for name, role in aws_iam_role.custom : name => role.arn
  }
}

output "custom_role_names" {
  description = "Map of custom role names"
  value = {
    for name, role in aws_iam_role.custom : name => role.name
  }
}

output "custom_role_ids" {
  description = "Map of custom role IDs"
  value = {
    for name, role in aws_iam_role.custom : name => role.id
  }
}

# Combined Role Outputs
output "all_role_arns" {
  description = "Map of all created role ARNs"
  value = merge(
    var.create_ecr_push_role ? { ecr_push = aws_iam_role.ecr_push[0].arn } : {},
    var.create_ecr_pull_role ? { ecr_pull = aws_iam_role.ecr_pull[0].arn } : {},
    var.create_application_role ? { application = aws_iam_role.application[0].arn } : {},
    var.create_lambda_execution_role ? { lambda_execution = aws_iam_role.lambda_execution[0].arn } : {},
    {
      for name, role in aws_iam_role.custom : name => role.arn
    }
  )
}

output "all_role_names" {
  description = "Map of all created role names"
  value = merge(
    var.create_ecr_push_role ? { ecr_push = aws_iam_role.ecr_push[0].name } : {},
    var.create_ecr_pull_role ? { ecr_pull = aws_iam_role.ecr_pull[0].name } : {},
    var.create_application_role ? { application = aws_iam_role.application[0].name } : {},
    var.create_lambda_execution_role ? { lambda_execution = aws_iam_role.lambda_execution[0].name } : {},
    {
      for name, role in aws_iam_role.custom : name => role.name
    }
  )
}

# ECR Repository Policy Outputs
output "ecr_repository_policy" {
  description = "The repository policy"
  value       = var.create_ecr_repository && var.ecr_repository_policy != null ? aws_ecr_repository_policy.main[0].policy : null
}

output "ecr_lifecycle_policy" {
  description = "The lifecycle policy"
  value       = var.create_ecr_repository && var.ecr_lifecycle_policy != null ? aws_ecr_lifecycle_policy.main[0].policy : null
}

# Default ECR Repository Policy
output "default_ecr_repository_policy" {
  description = "The default ECR repository policy document"
  value       = data.aws_iam_policy_document.ecr_repository_default.json
}

output "default_ecr_lifecycle_policy" {
  description = "The default ECR lifecycle policy document"
  value       = data.aws_iam_policy_document.ecr_lifecycle_default.json
} 