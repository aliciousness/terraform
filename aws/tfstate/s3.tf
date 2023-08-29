resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket          = "${var.tfstate_s3_bucket_name}"
  # lifecycle {
  #   prevent_destroy = true
  # }
  tags = {
    "creator"     = var.terraform_tags[0]
    "author"      = var.terraform_tags[1]
    "module"      = var.terraform_tags[2]
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform-state-ownership" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_versioning" "terraform-state-versioning" {
  bucket          = aws_s3_bucket.terraform-state-bucket.bucket
  versioning_configuration {
    status        = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-encryption" {
  bucket          = aws_s3_bucket.terraform-state-bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state-bucket-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform-state-block" {
 bucket = aws_s3_bucket.terraform-state-bucket.bucket
 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}
