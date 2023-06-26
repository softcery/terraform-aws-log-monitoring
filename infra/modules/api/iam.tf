// AWS ECS requires what it terms an “execution” IAM role, which is the IAM role used
// to gather all the elements needed to launch the container image. For instance,
// this role usually gathers permissions to access the ECR to grab the image,
// the secrets manager to pull secrets (and pass them to the container),
// and the KMS in order to get keys to decrypt secrets.
resource "aws_iam_role" "api" {
  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = "policy-${var.name}"
    policy = module.api_policy.json
  }
  tags = local.tags
}

// We attach that role to a built-in AWS policy called “AmazonECSTaskExecutionRolePolicy”,
// which grants common ECS execution rights, like accessing ECRs and writing to CloudWatch.
resource "aws_iam_role_policy_attachment" "ExecutionRole_to_ecsTaskExecutionRole" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ecs latest task definition
data "aws_ecs_task_definition" "latest_td" {
  task_definition = aws_ecs_task_definition.api.family
}

module "api_policy" {
  source                = "cloudposse/iam-policy/aws"
  version               = "0.4.0"
  iam_policy_statements = var.iam_policy_statements
}
