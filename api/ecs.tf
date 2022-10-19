
# ecs latest task definition
data "aws_ecs_task_definition" "latest_td" {
  task_definition = aws_ecs_task_definition.api.family
}

// ecs service for api
resource "aws_ecs_service" "api" {
  name            = var.name
  cluster         = var.ecs-cluster-id
  task_definition = data.aws_ecs_task_definition.latest_td.arn
  desired_count   = var.api-desired-count
  launch_type     = "EC2"
  tags            = var.tags

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  lifecycle {
    # create_before_destroy = true
    # ignore_changes = [task_definition]
  }
}

// ecs task definition for api
resource "aws_ecs_task_definition" "api" {
  family = var.name
  tags   = var.tags

  execution_role_arn       = aws_iam_role.api.arn
  task_role_arn            = aws_iam_role.api.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([
    {
      #image = "${var.ecr_repository}/${var.name}:latest"
      image = var.image_name
      name  = var.name

      memoryReservation = var.tdf_memory_reservation
      memory            = var.tdf_memory

      portMappings = [{
        containerPort = var.container_port
        hostPort      = 0
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : aws_cloudwatch_log_group.api.name,
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    },
  ])

  # lifecycle {
  #   create_before_destroy = true
  #   ignore_changes        = [container_definitions]
  # }
}

// log group for service logs
resource "aws_cloudwatch_log_group" "api" {
  name              = var.name
  retention_in_days = 30
  tags              = var.tags
}

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
  tags = var.tags
}

// We attach that role to a built-in AWS policy called “AmazonECSTaskExecutionRolePolicy”,
// which grants common ECS execution rights, like accessing ECRs and writing to CloudWatch.
resource "aws_iam_role_policy_attachment" "ExecutionRole_to_ecsTaskExecutionRole" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# // attach a policy that allows access to RDS
# resource "aws_iam_role_policy_attachment" "rds" {
#   role       = aws_iam_role.api.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
# }

// attach a policy that allows access to SNS
resource "aws_iam_role_policy_attachment" "ses" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

// attach a policy that allows access to S3
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.api.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
