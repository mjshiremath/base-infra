.PHONY: help plan apply destroy validate format init clean

TERRAGRUNT_DIR := terragrunt/dev
NETWORK_DIR := $(TERRAGRUNT_DIR)/network
EKS_DIR := $(TERRAGRUNT_DIR)/eks

help:
	@echo "Available targets:"
	@echo "  plan-all          - Plan all infrastructure changes"
	@echo "  plan-network      - Plan network changes"
	@echo "  plan-eks          - Plan EKS changes"
	@echo ""
	@echo "  apply-all         - Apply all infrastructure changes"
	@echo "  apply-network     - Apply network changes"
	@echo "  apply-eks         - Apply EKS changes"
	@echo ""
	@echo "  destroy-all       - Destroy all infrastructure"
	@echo "  destroy-network   - Destroy network"
	@echo "  destroy-eks       - Destroy EKS"
	@echo ""
	@echo "  validate-all      - Validate all Terraform files"
	@echo "  format-all        - Format all Terraform/Terragrunt files"
	@echo "  format-check      - Check Terraform formatting"
	@echo ""
	@echo "  init              - Initialize Terragrunt"
	@echo "  clean             - Clean Terragrunt cache"

# Plan targets
plan-all:
	cd $(TERRAGRUNT_DIR) && terragrunt plan-all

plan-network:
	cd $(NETWORK_DIR) && terragrunt plan

plan-eks:
	cd $(EKS_DIR) && terragrunt plan

# Apply targets
apply-all:
	cd $(TERRAGRUNT_DIR) && terragrunt apply-all

apply-network:
	cd $(NETWORK_DIR) && terragrunt apply

apply-eks:
	cd $(EKS_DIR) && terragrunt apply

# Destroy targets
destroy-all:
	cd $(TERRAGRUNT_DIR) && terragrunt destroy-all

destroy-network:
	cd $(NETWORK_DIR) && terragrunt destroy

destroy-eks:
	cd $(EKS_DIR) && terragrunt destroy

# Validate targets
validate-all:
	cd $(TERRAGRUNT_DIR) && terragrunt validate

# Format targets
format-all:
	terraform fmt -recursive .

format-check:
	terraform fmt -recursive -check .

# Init targets
init:
	cd $(TERRAGRUNT_DIR) && terragrunt init

# Clean targets
clean:
	find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
