variable "aws_region" {
  default = "ap-northeast-1"
}

variable "lgtmoon_aws_iam_user_name" {
  description = "LGTMoonからAWSを利用するためのIAMユーザー名"
}
variable "lgtmoon_aws_s3_bucket_name" {
  description = "LGTM画像をアップロードするS3バケットの名前"
}
variable "lgtmoon_aws_s3_policy" {
  description = "LGTM画像をアップロードするS3バケットにアクセス可能なポリシー"
}

provider "aws" {
  region = var.aws_region
  profile = "lgtmoon"
}

# LGTMoon アプリケーションから利用するユーザー
resource "aws_iam_user" "lgtmoon_user" {
  name = var.lgtmoon_aws_iam_user_name
}

# S3バケットを作成
resource "aws_s3_bucket" "lgtmoon_bucket" {
  bucket = var.lgtmoon_aws_s3_bucket_name
  acl = "private"
}

# S3バケットにアクセスできるようなポリシー
resource "aws_iam_policy" "lgtmoon_s3_policy" {
  name = var.lgtmoon_aws_s3_policy
  description = "for upload to LGTMoon S3 bucket"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.lgtmoon_aws_s3_bucket_name}/*"
    }
  ]
}
EOF
}

# ポリシーをLGTMoonアプリケーションユーザーにアタッチ
resource "aws_iam_user_policy_attachment" "lgtmoon_s3_policy_attach" {
  user = aws_iam_user.lgtmoon_user.name
  policy_arn = aws_iam_policy.lgtmoon_s3_policy.arn
}
