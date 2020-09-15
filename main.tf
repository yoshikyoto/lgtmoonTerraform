variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "ap-northeast-1"
}
variable "lgtmoon_aws_s3_bucket_name" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

resource "aws_s3_bucket" "lgtmoon_bucket" {
  bucket = var.lgtmoon_aws_s3_bucket_name
  acl = "private"
}
