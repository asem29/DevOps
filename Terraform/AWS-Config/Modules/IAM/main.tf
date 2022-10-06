
resource "aws_iam_role" "config_role" {
  name = "AWS-aws-config-UE1-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "p" {
  name = "awsconfigpolicy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "s3:*"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::${var.S3}",
            "arn:aws:s3:::${var.S3}/*"
          ]
        }
      ]

    }
  )
}

data "aws_iam_policy" "AWSconfig" {
  arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "attach1" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.p.arn
}
resource "aws_iam_role_policy_attachment" "attach2" {
  role       = aws_iam_role.config_role.name
  policy_arn = data.aws_iam_policy.AWSconfig.arn
}
