provider "aws" {
    region="us-east-1"


}


resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0
  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary
  tags = var.tags
}
