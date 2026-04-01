terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_schema" "tf_schema" {
  name = var.schema_name
  database = var.dbname
  data_retention_time_in_days = var.retention
}