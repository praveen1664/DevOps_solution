provider "aws" {
    region="us-east-1"
    access_key = "AKIAY5VQIE2KYNMWFBI3"
    secret_key = "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"
}

locals {
  group_name = element(concat(aws_iam_group.this.*.id, [var.name]), 0)
}

resource "aws_iam_group" "this" {
  count = var.create_group ? 1 : 0
  name = var.name
}

resource "aws_iam_group_membership" "this" {
  count = length(var.group_users) > 0 ? 1 : 0
  group = local.group_name
  name  = var.name
  users = var.group_users
  
}

