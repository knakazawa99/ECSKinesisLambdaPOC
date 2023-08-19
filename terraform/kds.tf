resource "aws_kinesis_stream" "ecs_kinesis_lambda_poc_kds" {
  name        = "${var.project_name}-kds"
  shard_count = 1
}
