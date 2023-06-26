resource "aws_sns_topic" "alarm_notification" {
  name = "${var.name}-alarms"
}

resource "aws_sns_topic" "budget_notification" {
  name = "${var.name}-budget-notification"
}

resource "aws_sns_topic_policy" "account_billing_alarm_policy" {
  arn    = aws_sns_topic.budget_notification.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {

  statement {
    sid    = "AWSBudgetsSNSPublishingPermissions"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.budget_notification.arn
    ]
  }
}
