terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_grant_account_role" "grant_acc_role" {
  role_name        = var.role_name
  parent_role_name = var.parent_role_name
}

resource "snowflake_grant_account_role" "grant_acc_role_user" {
  role_name        = var.role_name
  user_name = var.user_name
}