## Kinesis Firehose Role
resource "aws_iam_role" "ecs_kinesis_lambda_poc_kdf_role" {
  name               = "${var.project_name}-kdf-role"
  assume_role_policy = file("${path.module}/policies/kdf_trust_policy.json")
}

resource "aws_iam_policy" "ecs_kinesis_lambda_poc_kdf_policy" {
  name = "${var.project_name}-kdf-policy"
  policy = templatefile("${path.module}/policies/kdf_policy.json", {
    bucket_arn = aws_s3_bucket.ecs_kinesis_lambda_poc.arn
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.ecs_kinesis_lambda_poc_kdf_role.name
  policy_arn = aws_iam_policy.ecs_kinesis_lambda_poc_kdf_policy.arn
}

resource "aws_kinesis_firehose_delivery_stream" "ecs_kinesis_lambda_poc" {
  name        = "${var.project_name}-log"
  destination = "extended_s3"
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.ecs_kinesis_lambda_poc_kds.arn
    role_arn           = aws_iam_role.ecs_kinesis_lambda_poc_kdf_role.arn
  }
  extended_s3_configuration {
    role_arn        = aws_iam_role.ecs_kinesis_lambda_poc_kdf_role.arn
    bucket_arn      = aws_s3_bucket.ecs_kinesis_lambda_poc.arn
    buffer_size     = 128
    buffer_interval = 300

    prefix              = "log/dt=!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}/"
    error_output_prefix = "log_error/!{firehose:error-output-type}/dt=!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}/"

    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_database.ecs_kinesis_lambda_poc.name
        role_arn      = aws_iam_role.ecs_kinesis_lambda_poc_kdf_role.arn
        table_name    = aws_glue_catalog_table.test.name
      }
    }
  }
  depends_on = [
    aws_glue_catalog_database.ecs_kinesis_lambda_poc,
    aws_glue_catalog_table.test
  ]
}