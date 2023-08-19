resource "aws_iam_role" "ecs_kinesis_lambda_poc_lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = file("${path.module}/policies/lambda_trust_policy.json")
}

resource "aws_iam_policy" "ecs_kinesis_lambda_poc_lambda_policy" {
  name               = "${var.project_name}-lambda-policy"
  policy = file("${path.module}/policies/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_kinesis_lambda_poc_lambda_policy_attachment" {
  role       = aws_iam_role.ecs_kinesis_lambda_poc_lambda_role.name
  policy_arn = aws_iam_policy.ecs_kinesis_lambda_poc_lambda_policy.arn
}

resource "aws_lambda_function" "ecs_kinesis_lambda_poc_lambda_get_kds" {
  function_name = "${var.project_name}-get-kds-record"
  description   = ""
  package_type  = "Image"
  image_uri = "${aws_ecr_repository.ecs_kinesis_lambda_poc_lambda_ecr.repository_url}:latest"
  role          = aws_iam_role.ecs_kinesis_lambda_poc_lambda_role.arn
  memory_size   = 128
  timeout       = 30

  environment {
    variables = {
    }
  }

  depends_on = [
    aws_kinesis_stream.ecs_kinesis_lambda_poc_kds
  ]
}

resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
  batch_size = 10
  event_source_arn = aws_kinesis_stream.ecs_kinesis_lambda_poc_kds.arn
  enabled = true
  function_name = aws_lambda_function.ecs_kinesis_lambda_poc_lambda_get_kds.arn
  starting_position = "TRIM_HORIZON"

  depends_on = [
    aws_lambda_function.ecs_kinesis_lambda_poc_lambda_get_kds,
    aws_kinesis_stream.ecs_kinesis_lambda_poc_kds
  ]
}
