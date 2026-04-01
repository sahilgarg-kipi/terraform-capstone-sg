terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_database" "tf_db" {
  name = var.dbname
  comment = var.comment
  is_transient = var.is_transient
  data_retention_time_in_days = var.retention
}