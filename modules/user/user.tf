terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_user" "tf_user" {
  name                 = var.username
  login_name           = var.loginname
  comment              = var.comment
  password             = var.password
  must_change_password = var.change_pwd
}