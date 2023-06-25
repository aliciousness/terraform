resource "aws_kms_key" "family-bucket-key" {
 description                = "This key is used to encrypt bucket objects"
 deletion_window_in_days    = 10
 enable_key_rotation        = true

 tags = {
    "creator"               = var.terraform_tags[0]
    "author"                = var.terraform_tags[1]
    "module"                = var.terraform_tags[2]
  }
}

resource "aws_kms_alias" "family-key-alias" {
 name                       = "alias/${var.application}-${var.environment}-bucket-key"
 target_key_id              = aws_kms_key.family-bucket-key.key_id
}
## s3 bucket

resource "aws_s3_bucket" "s3-family-bucket" {
  bucket                    = "${var.application}-${var.environment}"


  tags = {
    "creator"               = var.terraform_tags[0]
    "author"                = var.terraform_tags[1]
    "module"                = var.terraform_tags[2]
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-family-encryption" {
  bucket                    = aws_s3_bucket.s3-family-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
    kms_master_key_id       = aws_kms_key.family-bucket-key.arn
    sse_algorithm           = "aws:kms"
    }

  }
}


resource "aws_s3_bucket_versioning" "family-bucket-versioning" {
  bucket                    = aws_s3_bucket.s3-family-bucket.bucket
  versioning_configuration {
    status                  = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "family-block" {
 bucket                     = aws_s3_bucket.s3-family-bucket.bucket
 block_public_acls          = true
 block_public_policy        = true
 ignore_public_acls         = true
 restrict_public_buckets    = true
}