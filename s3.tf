#S3 Bucket
resource "aws_s3_bucket" "securecart-bucket" {
  bucket = "securecart-unique-bucket-name-24032026"  # ⚠️ Must be globally unique

  tags = {
    Name = "securecart-bucket"
  }
}

#Block ALL Public Access
resource "aws_s3_bucket_public_access_block" "securecart-block" {
  bucket = aws_s3_bucket.securecart-bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#Set Region
/*provider "aws" {
  region = "us-east-1"
}*/

#Enable Versioning
resource "aws_s3_bucket_versioning" "securecart-versioning" {
  bucket = aws_s3_bucket.securecart-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Enable Server-Side Encryption (SSE)
resource "aws_s3_bucket_server_side_encryption_configuration" "securecart-encryption" {
  bucket = aws_s3_bucket.securecart-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}