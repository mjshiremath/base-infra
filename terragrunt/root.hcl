# Root terragrunt configuration

# Common variables used across all modules
inputs = {
  aws_region = "us-east-1"
  environment = "dev"

  common_tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    created_by  = "27925"
    ManagedWith = "Terragrunt"
  }
}

# Remote state configuration
remote_state {
  backend = "s3"

  config = {
    bucket = "practice-eks-state"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
