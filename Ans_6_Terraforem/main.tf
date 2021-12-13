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

###############################
# IAM Role for prod ci
###############################
module "prod_ci_role" {
  source = "./modules/create-role"
  #assume_role_policy = data.aws_iam_policy_document.assume_role.json
  trusted_role_arns = [
    #your account group arns here
    "arn:aws:iam::835367859851:group"
  ]

  trusted_role_services = [
    "codedeploy.amazonaws.com"
  ]
  create_role       = true
  role_name         = "prod-ci-role"
  attach_prod_ci_policy = true

  tags = {
    Role = "Prod-ci"
  }
}

###############################
# IAM Create user 1
###############################

module "prod-ci-user" {
  source = "./modules/create-user"
  name = "praveen"
}

###############################
# IAM Create group & add user whhic assume role policy
###############################
module "prod-ci-group" {
  source = "./modules/create-group"
  name = "prod-ci-group"
  create_group=true
  group_users = [
    "Praveen"
  ]
custom_group_policies=[
    {
      Name="aws_iam_policy_document"
      policy="$data.aws_iam_policy_document.assume_role"

    }
  ]
}





