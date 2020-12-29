variable "lgtmoon_aws_user_name" {
  description = "LGTMoonアプリから利用される AWS IAM のユーザー名"
}
variable "lgtmoon_bucket_name" {
  description = "LGTM画像をアップロードするS3バケットの名前"
}
variable "allow_put_lgtmoon_bucket_policy_name" {
  description = "LGTM画像をアップロードするS3バケットにアクセス可能なポリシー"
}

provider "aws" {
  # ~/.aws/credentials の [lgtmoon] を見る
  profile = "lgtmoon"

  # region は profile から読み込んでくれないので直接指定
  region = "ap-northeast-1"
}

# S3バケットを作成
resource "aws_s3_bucket" "lgtmoon_bucket" {
  // パブリックのアクセスを許可する
  bucket = var.lgtmoon_bucket_name
  // 誰でも GetObject になるような
  policy = data.aws_iam_policy_document.everyone_allow_get_object_in_lgtmoon_bucket.json
  acl = "public-read"
}

# LGTMoon アプリケーションから利用するユーザーを作成
resource "aws_iam_user" "lgtmoon_user" {
  name = var.lgtmoon_aws_user_name
}

# S3バケットにアクセスできるようなポリシーを作成
resource "aws_iam_policy" "allow_put_lgtmoon_bucket" {
  name = var.allow_put_lgtmoon_bucket_policy_name
  description = "for upload to LGTMoon S3 bucket"
  policy = data.aws_iam_policy_document.allow_put_lgtmoon_bucket.json
}
# ↑で利用するポリシードキュメント
data "aws_iam_policy_document" "allow_put_lgtmoon_bucket" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.lgtmoon_bucket_name}",
      "arn:aws:s3:::${var.lgtmoon_bucket_name}/*"
    ]
  }
}

# ポリシーをLGTMoonアプリケーションユーザーにアタッチ
resource "aws_iam_user_policy_attachment" "attach_policy_to_allow_lgtmoon_user_put_bucket" {
  user = aws_iam_user.lgtmoon_user.name
  policy_arn = aws_iam_policy.allow_put_lgtmoon_bucket.arn
}

# S3 の public access を可能にする設定
resource "aws_s3_bucket_public_access_block" "allow_public_access_to_lgtmoon_bucet" {
  bucket = aws_s3_bucket.lgtmoon_bucket.bucket
  block_public_acls = true
  block_public_policy = false
  ignore_public_acls = true
  restrict_public_buckets = false
}
# ↑で利用するポリシードキュメント
data "aws_iam_policy_document" "everyone_allow_get_object_in_lgtmoon_bucket" {
  statement {
    effect = "Allow"
    principals {
      # 誰でもアクセスできる
      identifiers = ["*"]
      type = "*"
    }
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${var.lgtmoon_bucket_name}",
      "arn:aws:s3:::${var.lgtmoon_bucket_name}/*"
    ]
  }
}
