resource "aws_glue_catalog_database" "ecs_kinesis_lambda_poc" {
  name = "${var.project_name}-db"
}


resource "aws_glue_catalog_table" "test" {
  name          = "test"
  database_name = aws_glue_catalog_database.ecs_kinesis_lambda_poc.name

  table_type = "EXTERNAL_TABLE"

  partition_keys {
    name = "dt"
    type = "string"
  }

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.ecs_kinesis_lambda_poc.bucket}/log/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "parquet_serde"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name    = "pat"
      type    = "timestamp"
      comment = "processed-at"
    }
    columns {
      name    = "id"
      type    = "string"
      comment = "id"
    }
    columns {
      name    = "lt"
      type    = "string"
      comment = "log type"
    }
  }
}
