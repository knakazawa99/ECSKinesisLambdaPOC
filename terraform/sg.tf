## VPC Security Groups

### Security Groups for Load Balancers
resource "aws_security_group" "alb_sg" {
  name   = "${var.project_name}-alb-sg"
  vpc_id = aws_vpc.ecs_kinesis_lambda_poc.id

  tags = {
    Name = var.tag
  }
}

resource "aws_security_group_rule" "alb_sg_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# API
resource "aws_security_group" "ecs_kinesis_lambda_api_sg" {
  name        = "ecs-kinesis-lambda-api-sd"
  description = "Bid API Security Group"
  vpc_id      = aws_vpc.ecs_kinesis_lambda_poc.id
  tags = {
    Name = var.tag
  }
}
resource "aws_security_group_rule" "ecs_kinesis_lambda_api_allow_http_inbound" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_kinesis_lambda_api_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "ecs_kinesis_lambda_api_allow_every_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_kinesis_lambda_api_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

