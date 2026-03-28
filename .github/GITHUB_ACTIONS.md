# GitHub Actions Pipelines for Infrastructure

This project uses GitHub Actions to automate infrastructure planning and deployment for EKS and Network resources.

## Workflows

### 1. **Infrastructure Plan & Apply** (`infrastructure.yml`)
Main workflow for planning and applying infrastructure changes.

#### Triggers:
- **Pull Requests**: Plans changes (network & EKS) and comments on PR
- **Push to main**: Auto-applies changes (network first, then EKS)
- **Workflow Dispatch**: Manual trigger with operation selection

#### Jobs:
- **Validate**: Validates Terraform/Terragrunt configuration
- **plan-network**: Plans network infrastructure changes
- **plan-eks**: Plans EKS infrastructure changes
- **apply-network**: Applies network changes (main branch only)
- **apply-eks**: Applies EKS changes (depends on network, main branch only)

### 2. **Infrastructure Destroy** (`destroy.yml`)
Manual workflow for destroying infrastructure (requires manual trigger).

#### Triggers:
- **Workflow Dispatch**: Manual trigger with target selection
  - `network`: Destroy network only
  - `eks`: Destroy EKS only
  - `all`: Destroy both network and EKS

#### Jobs:
- **destroy-network**: Destroys network infrastructure
- **destroy-eks**: Destroys EKS infrastructure

## Required Secrets

Configure in GitHub repository settings → Secrets and variables → Actions:

```
AWS_ROLE_TO_ASSUME
```
The AWS IAM role ARN for OIDC authentication (e.g., `arn:aws:iam::ACCOUNT_ID:role/github-actions-role`)

## Setup Instructions

### 1. Create AWS OIDC Identity Provider

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list "6e6de7410432e72cfe1a67b14ffc86a6c4d6e3c6" "1b511abead59c6ce207077c0ef0cae694e5fb13b"
```

### 2. Create GitHub Actions Role

```bash
cat > trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:GITHUB_ORG/REPO_NAME:ref:refs/heads/main"
        }
      }
    }
  ]
}
EOF

aws iam create-role \
  --role-name github-actions-role \
  --assume-role-policy-document file://trust-policy.json
```

### 3. Add Permissions to Role

```bash
aws iam put-role-policy \
  --role-name github-actions-role \
  --policy-name terraform-policy \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:*",
          "eks:*",
          "iam:*",
          "s3:*"
        ],
        "Resource": "*"
      }
    ]
  }'
```

### 4. Set Repository Secret

Add `AWS_ROLE_TO_ASSUME` secret with value:
```
arn:aws:iam::ACCOUNT_ID:role/github-actions-role
```

## Workflow Examples

### Plan on Pull Request
```
1. Create PR with changes to terragrunt/ or modules/
2. Workflow automatically runs validation
3. plan-network and plan-eks jobs run
4. Results posted as comments on PR
```

### Apply on Main
```
1. Merge PR to main
2. infrastructure.yml triggers
3. Network infrastructure applied first
4. EKS infrastructure applied after (depends on network)
```

### Manual Plan
```
1. Go to Actions → Infrastructure Plan & Apply
2. Click "Run workflow"
3. Select operation: plan-all, plan-network, plan-eks
4. View logs and artifacts
```

### Destroy Infrastructure
```
1. Go to Actions → Infrastructure Destroy
2. Click "Run workflow"
3. Select target: network, eks, or all
4. Confirm (requires environment: production approval)
5. Infrastructure destroyed
```

## Environment Protection

- **production** environment requires manual approval for apply/destroy operations
- Only runs on main branch for auto-apply
- All operations require valid AWS credentials via OIDC

## Artifacts

Workflows produce artifacts for audit and debugging:
- `network-plan` / `eks-plan`: Terraform plan output
- `network-apply-logs` / `eks-apply-logs`: Apply operation logs
- `network-destroy-logs` / `eks-destroy-logs`: Destroy operation logs

## Troubleshooting

### OIDC Authentication Failed
- Verify AWS_ROLE_TO_ASSUME secret is set correctly
- Check trust policy matches GitHub repository
- Ensure OIDC provider is created in AWS

### Terragrunt/Terraform Errors
- Check logs in GitHub Actions UI
- Run `make plan-network` or `make plan-eks` locally to debug
- Review artifact uploads for detailed logs

### Jobs Skipped
- Ensure file paths in workflow trigger match your structure
- Check branch protection rules allow auto-apply on main
- Verify secrets are configured in repository
