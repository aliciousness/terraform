output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform-state-bucket.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform-state-db-table.arn
  description = "The arn of the DynamoDB table"
}