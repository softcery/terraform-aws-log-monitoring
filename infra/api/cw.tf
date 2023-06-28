resource "aws_cloudwatch_log_group" "api" {
  name = var.name

  retention_in_days = var.log_retention

  tags = local.tags
}

resource "aws_cloudwatch_dashboard" "logs" {
  dashboard_name = "dashboard-${var.name}"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "log",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 14,
            "properties": {
                "region": "${var.region}",
                "title": "Application logs",
                "query": "SOURCE '${var.name}' | fields @timestamp, @message, @logStream, @log | sort @timestamp desc | filter @message not like \"ping\" | limit 100",
                "view": "table"
            }
        }
    ]
}
EOF
}
