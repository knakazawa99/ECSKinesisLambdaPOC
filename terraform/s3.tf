resource "aws_s3_bucket" "ecs_kinesis_lambda_poc" {
  bucket              = "${var.project_name}-objects"
  object_lock_enabled = true
}

resource "aws_s3_bucket_public_access_block" "batch_files_conf" {
  bucket                  = aws_s3_bucket.ecs_kinesis_lambda_poc.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
