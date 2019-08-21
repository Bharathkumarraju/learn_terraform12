output "bharath_s3_backend_arn" {
  value = aws_s3_bucket.bharath_tf_state_store.arn
  description = "The S3 Bucket ARN"
}

output "bharath_dynamodb_table_name" {
  value = aws_dynamodb_table.bharaths-terraform-locks.name
  description = "The Name of the Dynamo DB table"
}