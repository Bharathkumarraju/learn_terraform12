provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_iam_user" "bharaths_iam_users" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}