resource "aws_vpc" "ecs_kinesis_lambda_poc" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.tag
  }
  lifecycle {
    prevent_destroy = true
  }
}

# Public subnet on each availability zone.
resource "aws_subnet" "public-subnet-1a" {
  vpc_id            = aws_vpc.ecs_kinesis_lambda_poc.id
  cidr_block        = "10.1.0.0/22"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = var.tag
  }
}

resource "aws_subnet" "private-subnet-1a" {
  vpc_id            = aws_vpc.ecs_kinesis_lambda_poc.id
  cidr_block        = "10.1.8.0/22"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = var.tag
  }
}

resource "aws_subnet" "public-subnet-1c" {
  vpc_id            = aws_vpc.ecs_kinesis_lambda_poc.id
  cidr_block        = "10.1.4.0/22"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = var.tag
  }
}

resource "aws_subnet" "private-subnet-1c" {
  vpc_id            = aws_vpc.ecs_kinesis_lambda_poc.id
  cidr_block        = "10.1.12.0/22"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = var.tag
  }
}
