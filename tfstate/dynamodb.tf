resource "aws_dynamodb_table" "terraform-state-db-table" {
 name           = "${var.tfstate_dynamodb_table_name}"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }

  tags = {
    "creator" = var.terraform_tags[0]
    "author" = var.terraform_tags[1]
    "module" = var.terraform_tags[2]
  }
}
