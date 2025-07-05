
# IAM role for pushing to ECR
data "aws_iam_policy_document" "ecr_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecr_push_role" {
  name               = "ecr-push-role"
  assume_role_policy = data.aws_iam_policy_document.ecr_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecr_push_policy" {
  role       = aws_iam_role.ecr_push_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

