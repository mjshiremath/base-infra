

# EKS Fargate Pod Execution Role
data "aws_iam_policy_document" "fargate_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate_pod_execution_role" {
  name               = "eks-fargate-pod-execution-role"
  assume_role_policy = data.aws_iam_policy_document.fargate_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  role       = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

# EKS Cluster
resource "aws_eks_cluster" "fargate_eks" {
  name     = "fargate-eks-cluster"
  role_arn = aws_iam_role.fargate_pod_execution_role.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.eks_private_subnet_a.id
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.fargate_pod_execution_role_policy]
}

# EKS Fargate Profile
resource "aws_eks_fargate_profile" "default" {
  cluster_name           = aws_eks_cluster.fargate_eks.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = [
    aws_subnet.eks_private_subnet_a.id
  ]
  selector {
    namespace = "default"
  }
}