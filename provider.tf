terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
  }
}

provider "snowflake" {
  alias             = "sysadmin"
  organization_name = var.sf_org
  account_name      = var.sf_acc
  user              = "tf_service_user"
  role              = "SYSADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.sf_private_key_path)
}

provider "snowflake" {
  alias             = "useradmin"
  organization_name = var.sf_org
  account_name      = var.sf_acc
  user              = "tf_service_user"
  role              = "USERADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.sf_private_key_path)
}

provider "snowflake" {
  alias             = "securityadmin"
  organization_name = var.sf_org
  account_name      = var.sf_acc
  user              = "tf_service_user"
  role              = "SECURITYADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.sf_private_key_path)
}