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
            "x": 12,
            "y": 24,
            "width": 12,
            "height": 6,
            "properties": {
                "region": "${var.region}",
                "title": "Application logs",
                "query": "SOURCE '${var.name}' | fields @timestamp, @message, @logStream, @log | sort @timestamp desc | filter @message not like \"ping\" | limit 100"                "view": "table"
            }
        }
    ]
}
EOF
}
