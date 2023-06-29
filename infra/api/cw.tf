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
            "height": 5,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "log",
            "properties": {
                "region": "${var.region}",
                "title": "Application logs",
                "query": "SOURCE '${var.name}' | fields @timestamp, @message, @logStream, @log | sort @timestamp desc | filter @message not like \"ping\" | limit 100",
                "view": "table"
            }
        },
        {
            "type": "log",
            "x": 0,
            "y": 5,
            "width": 24,
            "height": 6,
            "properties": {
                "title": "API errors",
                "query": "SOURCE '${var.name}' | fields @timestamp, @message\n| filter @message like /\"severity\":\"(ERROR|FATAL)\"/\n| sort @timestamp desc",
                "region": "${var.region}",
                "stacked": false,
                "view": "table"
            }
        }
    ]
}
EOF
}
