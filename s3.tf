resource "aws_s3_bucket" "test_bucket" {
  bucket        = "public-test-bucket-123"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "test_bucket_access_block" {
  bucket                  = aws_s3_bucket.test_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
