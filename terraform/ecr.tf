resource "aws_ecr_repository" "ecs_kinesis_lambda_poc_api_ecr" {
  name = "${var.project_name}-api-ecr"
  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ecs_kinesis_lambda_poc_fluentbit_ecr" {
  name = "${var.project_name}-fluentbit"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }
  image_tag_mutability = "MUTABLE"
}
