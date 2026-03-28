# ECR Repository Variables
variable "create_ecr_repository" {
  description = "Whether to create an ECR repository"
  type        = bool
  default     = true
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "app-image-repo"
}

variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.ecr_image_tag_mutability)
    error_message = "ecr_image_tag_mutability must be one of: MUTABLE, IMMUTABLE."
  }
}

variable "ecr_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "ecr_encryption_type" {
  description = "The encryption type for the repository"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.ecr_encryption_type)
    error_message = "ecr_encryption_type must be one of: AES256, KMS."
  }
}

variable "ecr_repository_policy" {
  description = "The policy to be applied to the repository"
  type        = string
  default     = null
}

variable "ecr_lifecycle_policy" {
  description = "The lifecycle policy to be applied to the repository"
  type        = string
  default     = null
}

# ECR Push Role Variables
variable "create_ecr_push_role" {
  description = "Whether to create an ECR push role"
  type        = bool
  default     = true
}

variable "ecr_push_role_name" {
  description = "Name of the ECR push role"
  type        = string
  default     = "ecr-push-role"
}

variable "ecr_push_role_description" {
  description = "Description of the ECR push role"
  type        = string
  default     = "IAM role for pushing images to ECR"
}

variable "ecr_push_role_trusted_entities" {
  description = "Additional trusted entities for the ECR push role"
  type = list(object({
    type        = string
    identifiers = list(string)
    condition_test     = optional(string)
    condition_variable = optional(string)
    condition_values   = optional(list(string))
  }))
  default = []
}

# ECR Pull Role Variables
variable "create_ecr_pull_role" {
  description = "Whether to create an ECR pull role"
  type        = bool
  default     = false
}

variable "ecr_pull_role_name" {
  description = "Name of the ECR pull role"
  type        = string
  default     = "ecr-pull-role"
}

variable "ecr_pull_role_description" {
  description = "Description of the ECR pull role"
  type        = string
  default     = "IAM role for pulling images from ECR"
}

variable "ecr_pull_role_trusted_entities" {
  description = "Additional trusted entities for the ECR pull role"
  type = list(object({
    type        = string
    identifiers = list(string)
    condition_test     = optional(string)
    condition_variable = optional(string)
    condition_values   = optional(list(string))
  }))
  default = []
}

# Application Role Variables
variable "create_application_role" {
  description = "Whether to create an application role"
  type        = bool
  default     = false
}

variable "application_role_name" {
  description = "Name of the application role"
  type        = string
  default     = "application-role"
}

variable "application_role_description" {
  description = "Description of the application role"
  type        = string
  default     = "IAM role for application services"
}

variable "application_role_trusted_entities" {
  description = "Trusted entities for the application role"
  type = list(object({
    type        = string
    identifiers = list(string)
    condition_test     = optional(string)
    condition_variable = optional(string)
    condition_values   = optional(list(string))
  }))
  default = []
}

variable "application_role_policy" {
  description = "Custom policy for the application role"
  type        = string
  default     = null
}

variable "application_role_policy_arns" {
  description = "List of policy ARNs to attach to the application role"
  type        = list(string)
  default     = []
}

# Lambda Execution Role Variables
variable "create_lambda_execution_role" {
  description = "Whether to create a Lambda execution role"
  type        = bool
  default     = false
}

variable "lambda_execution_role_name" {
  description = "Name of the Lambda execution role"
  type        = string
  default     = "lambda-execution-role"
}

variable "lambda_execution_role_description" {
  description = "Description of the Lambda execution role"
  type        = string
  default     = "IAM role for Lambda function execution"
}

variable "lambda_execution_role_trusted_entities" {
  description = "Additional trusted entities for the Lambda execution role"
  type = list(object({
    type        = string
    identifiers = list(string)
    condition_test     = optional(string)
    condition_variable = optional(string)
    condition_values   = optional(list(string))
  }))
  default = []
}

variable "lambda_execution_role_policy_arns" {
  description = "List of policy ARNs to attach to the Lambda execution role"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

# Custom Roles Variables
variable "custom_roles" {
  description = "Map of custom IAM roles to create"
  type = map(object({
    name                 = string
    description          = optional(string)
    assume_role_policy   = string
    path                 = optional(string)
    max_session_duration = optional(number)
    tags                 = optional(map(string))
  }))
  default = {}
}

variable "custom_role_policy_attachments" {
  description = "List of custom role policy attachments"
  type = list(object({
    role_name   = string
    policy_arn  = string
  }))
  default = []
}

variable "custom_role_policies" {
  description = "Map of custom role policies to create"
  type = map(object({
    name   = string
    role_name = string
    policy = string
  }))
  default = {}
}

# General IAM Variables
variable "iam_role_path" {
  description = "Path for IAM roles"
  type        = string
  default     = "/"
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration in seconds for IAM roles"
  type        = number
  default     = 3600
  validation {
    condition     = var.iam_role_max_session_duration >= 3600 && var.iam_role_max_session_duration <= 43200
    error_message = "iam_role_max_session_duration must be between 3600 and 43200 seconds."
  }
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
} 