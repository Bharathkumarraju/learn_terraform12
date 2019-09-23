
provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_iam_user" "bharth_user" {
  for_each = toset(var.user_names)
  name = each.value
}

