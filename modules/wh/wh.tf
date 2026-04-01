terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

resource "snowflake_warehouse" "tf_wh" {
  name = var.whname
  warehouse_type = var.whtype
  warehouse_size = var.whsize
  auto_suspend = var.wh_autosuspend
  auto_resume = var.wh_autoresume
  comment = var.wh_comment
}