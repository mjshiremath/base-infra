# ECR Repository
resource "aws_ecr_repository" "main" {
  count = var.create_ecr_repository ? 1 : 0

  name                 = var.ecr_repository_name
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  encryption_configuration {
    encryption_type = var.ecr_encryption_type
  }

  tags = merge(
    {
      Name = var.ecr_repository_name
    },
    var.tags
  )
}

# ECR Repository Policy
resource "aws_ecr_repository_policy" "main" {
  count = var.create_ecr_repository && var.ecr_repository_policy != null ? 1 : 0

  repository = aws_ecr_repository.main[0].name
  policy     = var.ecr_repository_policy
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "main" {
  count = var.create_ecr_repository && var.ecr_lifecycle_policy != null ? 1 : 0

  repository = aws_ecr_repository.main[0].name
  policy     = var.ecr_lifecycle_policy
}

# ECR Push Role
resource "aws_iam_role" "ecr_push" {
  count = var.create_ecr_push_role ? 1 : 0

  name                 = var.ecr_push_role_name
  description          = var.ecr_push_role_description
  assume_role_policy   = data.aws_iam_policy_document.ecr_push_assume_role.json
  path                 = var.iam_role_path
  max_session_duration = var.iam_role_max_session_duration

  tags = merge(
    {
      Name = var.ecr_push_role_name
    },
    var.tags
  )
}

# ECR Push Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecr_push" {
  count = var.create_ecr_push_role ? 1 : 0

  role       = aws_iam_role.ecr_push[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# ECR Pull Role
resource "aws_iam_role" "ecr_pull" {
  count = var.create_ecr_pull_role ? 1 : 0

  name                 = var.ecr_pull_role_name
  description          = var.ecr_pull_role_description
  assume_role_policy   = data.aws_iam_policy_document.ecr_pull_assume_role.json
  path                 = var.iam_role_path
  max_session_duration = var.iam_role_max_session_duration

  tags = merge(
    {
      Name = var.ecr_pull_role_name
    },
    var.tags
  )
}

# ECR Pull Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecr_pull" {
  count = var.create_ecr_pull_role ? 1 : 0

  role       = aws_iam_role.ecr_pull[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Application Role
resource "aws_iam_role" "application" {
  count = var.create_application_role ? 1 : 0

  name                 = var.application_role_name
  description          = var.application_role_description
  assume_role_policy   = data.aws_iam_policy_document.application_assume_role.json
  path                 = var.iam_role_path
  max_session_duration = var.iam_role_max_session_duration

  tags = merge(
    {
      Name = var.application_role_name
    },
    var.tags
  )
}

# Application Role Policy
resource "aws_iam_role_policy" "application" {
  count = var.create_application_role ? 1 : 0

  name = "${var.application_role_name}-policy"
  role = aws_iam_role.application[0].id

  policy = var.application_role_policy != null ? var.application_role_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# Application Role Policy Attachments
resource "aws_iam_role_policy_attachment" "application" {
  for_each = var.create_application_role ? toset(var.application_role_policy_arns) : []

  role       = aws_iam_role.application[0].name
  policy_arn = each.value
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_execution" {
  count = var.create_lambda_execution_role ? 1 : 0

  name                 = var.lambda_execution_role_name
  description          = var.lambda_execution_role_description
  assume_role_policy   = data.aws_iam_policy_document.lambda_execution_assume_role.json
  path                 = var.iam_role_path
  max_session_duration = var.iam_role_max_session_duration

  tags = merge(
    {
      Name = var.lambda_execution_role_name
    },
    var.tags
  )
}

# Lambda Execution Role Policy Attachments
resource "aws_iam_role_policy_attachment" "lambda_execution" {
  for_each = var.create_lambda_execution_role ? toset(var.lambda_execution_role_policy_arns) : []

  role       = aws_iam_role.lambda_execution[0].name
  policy_arn = each.value
}

# Custom Roles
resource "aws_iam_role" "custom" {
  for_each = var.custom_roles

  name                 = each.value.name
  description          = lookup(each.value, "description", null)
  assume_role_policy   = each.value.assume_role_policy
  path                 = lookup(each.value, "path", var.iam_role_path)
  max_session_duration = lookup(each.value, "max_session_duration", var.iam_role_max_session_duration)

  tags = merge(
    {
      Name = each.value.name
    },
    lookup(each.value, "tags", {}),
    var.tags
  )
}

# Custom Role Policy Attachments
resource "aws_iam_role_policy_attachment" "custom" {
  for_each = {
    for attachment in var.custom_role_policy_attachments : "${attachment.role_name}-${attachment.policy_arn}" => attachment
  }

  role       = aws_iam_role.custom[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

# Custom Role Policies
resource "aws_iam_role_policy" "custom" {
  for_each = var.custom_role_policies

  name = each.value.name
  role = aws_iam_role.custom[each.value.role_name].id
  policy = each.value.policy
} 