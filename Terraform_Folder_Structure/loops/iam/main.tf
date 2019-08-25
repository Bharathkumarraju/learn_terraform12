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