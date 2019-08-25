provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_iam_user" "bharaths_iam_users" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}

data "aws_iam_policy_document" "ec2_readonly" {
  statement {
    effect = "Allow"
    actions = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_readonly" {
  name = "ec2-read-only"
  policy = data.aws_iam_policy_document.ec2_readonly.json
}

resource "aws_iam_policy_attachment" "ec2_access" {
  name = "ec2-policy-attachment"
  count = length(var.user_names)
  users = element(aws_iam_user.bharaths_iam_users[*].name, count.index)
  # Above one also can be written as below
  # users = aws_iam_user.bharaths_iam_users[count.index].name
  policy_arn = aws_iam_policy.ec2_readonly.arn
}