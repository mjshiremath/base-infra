# ECR Push Role Assume Role Policy
data "aws_iam_policy_document" "ecr_push_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.ecr_push_role_trusted_entities
    content {
      actions = ["sts:AssumeRole"]
      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }
      condition {
        test     = lookup(statement.value, "condition_test", null)
        variable = lookup(statement.value, "condition_variable", null)
        values   = lookup(statement.value, "condition_values", null)
      }
    }
  }
}

# ECR Pull Role Assume Role Policy
data "aws_iam_policy_document" "ecr_pull_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.ecr_pull_role_trusted_entities
    content {
      actions = ["sts:AssumeRole"]
      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }
      condition {
        test     = lookup(statement.value, "condition_test", null)
        variable = lookup(statement.value, "condition_variable", null)
        values   = lookup(statement.value, "condition_values", null)
      }
    }
  }
}

# Application Role Assume Role Policy
data "aws_iam_policy_document" "application_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.application_role_trusted_entities
    content {
      actions = ["sts:AssumeRole"]
      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }
      condition {
        test     = lookup(statement.value, "condition_test", null)
        variable = lookup(statement.value, "condition_variable", null)
        values   = lookup(statement.value, "condition_values", null)
      }
    }
  }
}

# Lambda Execution Role Assume Role Policy
data "aws_iam_policy_document" "lambda_execution_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.lambda_execution_role_trusted_entities
    content {
      actions = ["sts:AssumeRole"]
      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }
      condition {
        test     = lookup(statement.value, "condition_test", null)
        variable = lookup(statement.value, "condition_variable", null)
        values   = lookup(statement.value, "condition_values", null)
      }
    }
  }
}

# ECR Repository Policy (Default)
data "aws_iam_policy_document" "ecr_repository_default" {
  statement {
    sid    = "AllowPull"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = var.create_ecr_pull_role ? [aws_iam_role.ecr_pull[0].arn] : []
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
  }

  statement {
    sid    = "AllowPush"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = var.create_ecr_push_role ? [aws_iam_role.ecr_push[0].arn] : []
    }
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
  }
}

# ECR Lifecycle Policy (Default)
data "aws_iam_policy_document" "ecr_lifecycle_default" {
  statement {
    sid       = "ExpireImages"
    effect    = "Allow"
    actions   = ["ecr:DeleteImage"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ecr:ResourceTag/ImageTag"
      values   = ["*"]
    }
  }
} 