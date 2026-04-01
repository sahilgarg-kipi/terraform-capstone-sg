terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_account_role" "tf_fr_role" {
  name = var.role_name
  comment = var.comment
}