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

/*
The difference between element and array lookups is what happens if you try to access an index that is out of bounds.
For example, if you tried look up index 4 in an array with only 3 items,
the array lookup would give you an error,
whereas the element function will loop around using a standard mod algorithm, returning the item at index 1.
*/

resource "aws_iam_user_policy_attachment" "ec2_access" {
  count = length(var.user_names)
  policy_arn = aws_iam_policy.ec2_readonly.arn
  user = element(aws_iam_user.bharaths_iam_users[*].name, count.index)
  # Above one can also be written as
  # user = aws_iam_user.bharaths_iam_users[count.index].name
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  policy = data.aws_iam_policy_document.clouwatch_readonly.json
  name = "cloud-watch-readonly"
}

data "aws_iam_policy_document" "clouwatch_readonly" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
  name = "cloudwatch-full-access"
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}


resource "aws_iam_user_policy_attachment" "hanuman_cloudwatch_full_access" {
  count = var.give_hanuman_cloudwatch_full_access ? 1 : 0
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
  user = aws_iam_user.bharaths_iam_users[1].name
}

resource "aws_iam_user_policy_attachment" "hanuman_cloudwatch_readonly_access" {
  count = var.give_hanuman_cloudwatch_full_access ? 0 : 1
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
  user = aws_iam_user.bharaths_iam_users[1].name
}