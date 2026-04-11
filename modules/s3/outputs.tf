output "bucket_name" {
  description = "Name of the S3 bucket."
  value       = aws_s3_bucket.secure-s3.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.secure-s3.arn
}

output "bucket_id" {
  description = "ID of the S3 bucket."
  value       = aws_s3_bucket.secure-s3.id
}

output "bucket_region" {
  description = "Region where the S3 bucket resides."
  value       = aws_s3_bucket.secure-s3.region
}
