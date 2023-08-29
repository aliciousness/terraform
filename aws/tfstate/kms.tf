resource "aws_kms_key" "state-bucket-key" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true

 tags = {
    "creator" = var.terraform_tags[0]
    "author" = var.terraform_tags[1]
    "module" = var.terraform_tags[2]
  }
}

resource "aws_kms_alias" "state-key-alias" {
 name          = "alias/state-bucket-key"
 target_key_id = aws_kms_key.state-bucket-key.key_id
}
