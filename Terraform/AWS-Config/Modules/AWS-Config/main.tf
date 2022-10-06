
resource "aws_sns_topic" "sns" {
  name = "AWS-AWSCONFIG-UE1"
}

resource "aws_sns_topic_policy" "snspolicy" {
  arn = aws_sns_topic.sns.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]


    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.sns.arn
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_config_configuration_recorder" "config" {
  name = "Record"
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
  role_arn = var.IAM_Role
}

resource "aws_config_delivery_channel" "config" {
  name           = "Delivery"
  s3_bucket_name = var.S3
  sns_topic_arn  = aws_sns_topic.sns.arn

  depends_on = [aws_config_configuration_recorder.config, aws_sns_topic.sns]
}

resource "aws_config_configuration_recorder_status" "config" {
  is_enabled = true
  name       = aws_config_configuration_recorder.config.name
  depends_on = [aws_config_delivery_channel.config]
}

resource "aws_config_config_rule" "r" {
  count = length(var.aws_config_rules)
  name  = var.aws_config_rules[count.index]

  source {
    owner             = "AWS"
    source_identifier = var.aws_config_rules[count.index]

  }
  depends_on = [aws_config_configuration_recorder.config]
}
