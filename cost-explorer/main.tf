terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "lambda-cost-${var.postfix}"
  source_path = [
    "${path.module}/src"
  ]
  description = "CostExplorer"
  handler     = "lambda_function.lambda_handler"
  runtime     = "python3.9"
  memory_size = "128"
  timeout     = "5"

  cloudwatch_logs_retention_in_days = "1"

  environment_variables = merge(tomap({
    PERIOD         = var.period
    SLACK_ENDPOINT = var.slack_endpoint,
    SLACK_CHANNEL = var.slack_channel }),
    var.env
  )

  attach_policy_json = true
  policy_json        = <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ce:GetCostAndUsageWithResources",
                    "ce:GetCostAndUsage"
                ],
                "Resource": ["*"]
            }
        ]
    }
  EOT
}