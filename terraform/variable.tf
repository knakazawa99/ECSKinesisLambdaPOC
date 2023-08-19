variable "tag" {
  default = "ecs-kinesis-lambda-poc"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "project_name" {
  default = "ecs-kinesis-lambda-poc"
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "log_s3_location" {
  default = "ecs-kinesis-lambda-poc-bucket"
}
