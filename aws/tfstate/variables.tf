#
# tfstate variables
#
variable "tfstate_s3_bucket_name" {
    description = "The name of the remote tfstate file s3 bucket"
}
variable "tfstate_dynamodb_table_name" {
    description = "name of the tfstate dynamoDB table for locking the state file"
}
variable "terraform_tags" {
  description = "A simple array of tags used to indicate who, how and why a resource was made"
}