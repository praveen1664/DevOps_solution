provider "aws" {
    region="us-east-1"
    access_key = "AKIAY5VQIE2KYNMWFBI3"
    secret_key = "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"
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.trusted_role_arns
    }

    principals {
      type        = "Service"
      identifiers = var.trusted_role_services
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0
  name                 = var.role_name
  path                 = var.role_path
  description          = var.role_description
  permissions_boundary  = var.role_permissions_boundary_arn
  tags                  = var.tags
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}





