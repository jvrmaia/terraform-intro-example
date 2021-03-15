variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 3.0"

  name                          = "test-user"
  force_destroy                 = true
  create_iam_user_login_profile = false
}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 3.0"

  trusted_role_arns = [
    module.iam_user.this_iam_user_arn
  ]

  create_admin_role = true

  create_poweruser_role = true
  poweruser_role_name   = "developer"

  create_readonly_role       = true
  readonly_role_requires_mfa = false
}

output "access_key_id" {
  description = "test-user ACCESS_KEY_ID"
  value       = module.iam_user.this_iam_access_key_id
}

output "access_key_secret" {
  description = "test-user ACCESS_KEY_SECRET"
  value       = module.iam_user.this_iam_access_key_secret
  sensitive   = true
}
