# ═══════════════════════════════════════════════════════════
#  Module: s3
#  Resources: S3 Bucket, Public Access Block,
#             Versioning, Server-Side Encryption
# ═══════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# S3 Bucket
# ─────────────────────────────────────────────
resource "aws_s3_bucket" "secure-s3" {
  bucket = var.s3_bucket_name

  # Prevent accidental deletion when bucket has objects
  force_destroy = false

  tags = {
    Name = var.s3_bucket_name
  }
}

# ─────────────────────────────────────────────
# Block ALL Public Access
# Ensures no object or bucket ACL can make data public
# ─────────────────────────────────────────────
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.secure-s3.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ─────────────────────────────────────────────
# Versioning
# Enables point-in-time recovery and protects against overwrites
# ─────────────────────────────────────────────
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.secure-s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ─────────────────────────────────────────────
# Server-Side Encryption (SSE-S3 / AES-256)
# Encrypts all objects at rest by default.
# For stricter control, switch sse_algorithm to "aws:kms"
# and supply a kms_master_key_id.
# ─────────────────────────────────────────────
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.secure-s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# ─────────────────────────────────────────────
# Lifecycle Rule
# Transitions non-current versions to IA after 30 days,
# then expires them after 90 days to control storage costs.
# ─────────────────────────────────────────────
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.secure-s3.id

  # Must have versioning enabled before lifecycle rules can reference noncurrent versions
  depends_on = [aws_s3_bucket_versioning.this]

  rule {
    id     = "noncurrent-version-cleanup"
    status = "Enabled"

    filter {} # Apply rule to all objects in the bucket

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
