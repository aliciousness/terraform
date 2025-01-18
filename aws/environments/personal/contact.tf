# Get S3 bucket
data "aws_s3_bucket" "website" {
  bucket = "richardcraddock.me"
}

# Get the Cloudfront distribution
data "aws_cloudfront_distribution" "website" {
  id = "EUSUKVIPIH45U"
}

module "resume_contact" {
  source = "../../modules/contact"

  application           = local.application
  environment           = local.environment
  terraform_tags        = data.aws_default_tags.current.tags
  telegram_chat_id      = var.telegram_chat_id
  telegram_bot_token    = var.telegram_bot_token
  vpc                   = module.vpc-personal
  cache_cluster_enabled = true
  metrics_enabled       = true
  logging_level         = "ERROR"
  enable_waf            = true
}


resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = data.aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = [
      "Authorization",
      "Content-Type",
      "X-Api-Key",
      "X-Amz-Date",
      "X-Amz-Security-Token"
    ]
    allowed_methods = ["GET", "POST"]
    # allowed_origins = ["${data.aws_cloudfront_distribution.website.domain_name}"] # Uncomment when ready for release
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
