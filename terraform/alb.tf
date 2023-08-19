resource "aws_alb" "ecs_kinesis_lambda_poc_alb" {
  name = "${var.project_name}-alb"
  subnets = [
    aws_subnet.public-subnet-1a.id,
    aws_subnet.public-subnet-1c.id,
  ]
  security_groups            = aws_security_group.alb_sg.*.id
  internal                   = false
  enable_deletion_protection = false
  load_balancer_type         = "application"
  #
  #  access_logs {
  #    bucket  = aws_s3_bucket.ecs_kinesis_lambda_poc.bucket
  #    prefix  = "sys-logs"
  #    enabled = true
  #  }

  tags = {
    Name = var.tag
  }
}

resource "aws_alb_target_group" "ecs_kinesis_lambda_poc_tg" {
  name                 = "${var.project_name}-alb-tg"
  port                 = 8080
  deregistration_delay = 15
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.ecs_kinesis_lambda_poc.id
  health_check {
    interval = 30
    path     = "/healthz"
    matcher  = 200
    port     = 8080
  }
  depends_on = [
    aws_alb.ecs_kinesis_lambda_poc_alb
  ]

  tags = {
    Name = var.tag
  }
}

resource "aws_alb_listener" "ecs_kinesis_lambda_poc_listener" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = aws_alb.ecs_kinesis_lambda_poc_alb.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
  tags = {
    Name = var.tag
  }
}

resource "aws_alb_listener_rule" "ecs_kinesis_lambda_poc_listener_rule" {
  listener_arn = aws_alb_listener.ecs_kinesis_lambda_poc_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_kinesis_lambda_poc_tg.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  depends_on = [
    aws_alb.ecs_kinesis_lambda_poc_alb,
    aws_alb_listener.ecs_kinesis_lambda_poc_listener
  ]

  tags = {
    Name = var.tag
  }
}
