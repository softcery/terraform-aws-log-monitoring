// ecs task definition for api
resource "aws_ecs_task_definition" "api" {
  family = var.name

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.api.arn
  task_role_arn      = aws_iam_role.api.arn

  cpu    = var.cpu
  memory = var.memory

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name  = var.name
      image = var.image

      stopTimeout = 10

      portMappings = [{
        containerPort = var.port
        hostPort      = var.port
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : aws_cloudwatch_log_group.api.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      }

      environment = var.env_vars
    },
  ])

  tags = local.tags
}
