# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {

  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = var.tag
  }
}

# IAM
resource "aws_iam_role" "ecs_kinesis_lambda_poc_ecs_task_role" {
  name               = "${var.project_name}-ecs-role"
  assume_role_policy = file("${path.module}/policies/ecs_task_trust_policy.json")
}
resource "aws_iam_policy" "ecs_kinesis_lambda_poc_ecs_task_role_policy" {
  name   = "${var.project_name}-ecs-policy"
  policy = file("${path.module}/policies/ecs_task_policy.json")
}
resource "aws_iam_role_policy_attachment" "ecs_kinesis_lambda_poc_ecs_task_role_attachment" {
  role       = aws_iam_role.ecs_kinesis_lambda_poc_ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_kinesis_lambda_poc_ecs_task_role_policy.arn
}
resource "aws_iam_role_policy_attachment" "console_api_cloudwatch_policy_attachment" {
  role       = aws_iam_role.ecs_kinesis_lambda_poc_ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

## Execution Role
resource "aws_iam_role" "ecs_kinesis_lambda_poc_ecs_task_execution_role" {
  name               = "${var.project_name}-ecs-execution-role"
  assume_role_policy = file("${path.module}/policies/ecs_task_trust_policy.json")
}
resource "aws_iam_role_policy_attachment" "ecs_kinesis_lambda_poc_ecs_task_execution_role_attachment" {
  role       = aws_iam_role.ecs_kinesis_lambda_poc_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "ecs_kinesis_lambda_poc_ecs_api_lg" {
  name              = "/aws/ecs/${var.project_name}-api-service/firelens"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs_kinesis_lambda_poc_ecs_api_lg_logs" {
  name              = "/aws/ecs/${var.project_name}-api-service/logs"
  retention_in_days = 7
}


resource "aws_ecs_task_definition" "ecs_kinesis_lambda_api_task" {
  family = "${var.project_name}-api"
  container_definitions = templatefile("${path.module}/ecs-task-definitions/api.json", {
    ecs_kinesis_lambda_api_ecr       = aws_ecr_repository.ecs_kinesis_lambda_poc_api_ecr.repository_url
    ecs_kinesis_lambda_fluentbit_ecr = aws_ecr_repository.ecs_kinesis_lambda_poc_fluentbit_ecr.repository_url
    cw_log_group_name                = aws_cloudwatch_log_group.ecs_kinesis_lambda_poc_ecs_api_lg.name
    kds_stream                       = aws_kinesis_stream.ecs_kinesis_lambda_poc_kds.name
  })
  requires_compatibilities = ["FARGATE"]
  skip_destroy             = false
  task_role_arn            = aws_iam_role.ecs_kinesis_lambda_poc_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_kinesis_lambda_poc_ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  tags = {
    Name = var.tag
  }
}


resource "aws_ecs_service" "ecs_kinesis_lambda_poc_ecs_service" {
  name                               = "${var.project_name}-ecs-service"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_kinesis_lambda_api_task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"

  network_configuration {
    assign_public_ip = true
    subnets = [
      aws_subnet.public-subnet-1a.id,
      aws_subnet.public-subnet-1c.id,
    ]
    security_groups = [aws_security_group.ecs_kinesis_lambda_api_sg.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_kinesis_lambda_poc_tg.arn
    container_name   = "ecs-kinesis-lambda-api"
    container_port   = 8080
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  depends_on = [
    aws_cloudwatch_log_group.ecs_kinesis_lambda_poc_ecs_api_lg
  ]
  tags = {
    Name = var.tag
  }
}