output "all_users" {
  value = aws_iam_user.bharth_user
}

output "all_arns" {
  value = values(aws_iam_user.bharth_user)[*].arn
}
