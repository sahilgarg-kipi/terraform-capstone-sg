terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "tf_grant_priviledge" {
  privileges = var.privileges
  account_role_name = var.acc_role_name

  on_account_object {
    object_type = var.object_type
    object_name = var.object_name
  }
}