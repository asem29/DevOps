
resource "aws_s3_bucket" "bucket" {
  bucket = var.S3_Bucket
}


data "aws_iam_policy_document" "config" {
  statement {
    actions = ["s3:*"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.id}"]
  }
}


resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.config.json
}