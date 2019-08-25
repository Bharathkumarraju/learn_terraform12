output "first_arn" {
  value = aws_iam_user.bharaths_iam_users[0].arn
  description = "Arn of the 1st user"
}

output "second_arn" {
  value = aws_iam_user.bharaths_iam_users[1].arn
  description = "ARN of the 2nd user"
}

output "third_arn" {
  value = aws_iam_user.bharaths_iam_users[2].arn
  description = "ARN of the 3rd user"
}

output "all_Arns" {
  value = aws_iam_user.bharaths_iam_users[*].arn
  description = "The ARNs of all users"
}