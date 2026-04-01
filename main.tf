locals {
  env     = terraform.workspace
  dbnames = ["TF_RAW_${terraform.workspace}_DB", "TF_TRANS_${terraform.workspace}_DB"]

  acc_roles = {
    "FR_${terraform.workspace}_DATA_ENGINEER" = {
      "user"          = var.users["user1"].username
      "warehouse"     = "WH_${terraform.workspace}_DATA_ENGINEER"
      "wh_privileges" = ["USAGE", "OPERATE", "MONITOR"]
    }
    "FR_${terraform.workspace}_DATA_SCIENCE" = {
      "user"          = var.users["user2"].username
      "warehouse"     = "WH_${terraform.workspace}_DATA_SCIENCE"
      "wh_privileges" = ["USAGE"]
    }
  }

  raw_schemas   = ["API", "PG"]
  trans_schemas = ["HARMONIZED"]
  wh_names      = ["WH_${terraform.workspace}_DATA_ENGINEER", "WH_${terraform.workspace}_DATA_SCIENCE"]

  db_config = {
    for name in local.dbnames : name => {
      dbname       = upper(name)
      comment      = var.db_list[local.env].comment
      is_transient = var.db_list[local.env].is_transient
      retention    = var.db_list[local.env].retention
    }
  }

  acc_role_config = {
    for k, v in local.acc_roles : upper(k) => {
      role_name        = upper(k)
      comment          = "This comment is for ${upper(k)} role"
      parent_role_name = "SYSADMIN"
      user_name        = v.user
      warehouse        = upper(v.warehouse)
      wh_privileges    = v.wh_privileges
    }
  }

  schema_config = flatten([
    for name in local.dbnames : [
      for s in(
        strcontains(lower(name), "raw") ? local.raw_schemas :
        strcontains(lower(name), "trans") ? local.trans_schemas : []
        ) : {
        db_name     = upper(name)
        schema_name = s
        retention   = local.db_config[name].retention
      }
    ]
  ])

  wh_config = {
    for name in local.wh_names : name => {
      whname         = upper(name)
      whtype         = var.wh_list[terraform.workspace].whtype
      whsize         = var.wh_list[terraform.workspace].whsize
      wh_autosuspend = var.wh_list[terraform.workspace].wh_autosuspend
      wh_comment     = var.wh_list[terraform.workspace].wh_comment
      wh_autoresume  = var.wh_list[terraform.workspace].wh_autoresume
    }
  }

}


module "db_module" {
  source = "./modules/db"
  providers = {
    snowflake = snowflake.sysadmin
  }
  for_each     = local.db_config
  dbname       = each.value.dbname
  comment      = each.value.comment
  is_transient = each.value.is_transient
  retention    = each.value.retention
}


module "rolemodule" {
  source = "./modules/acc_roles"
  providers = {
    snowflake = snowflake.useradmin
  }
  for_each  = local.acc_role_config
  role_name = each.value.role_name
  comment   = each.value.comment
}


module "schemamodule" {
  source = "./modules/schema"
  providers = {
    snowflake = snowflake.sysadmin
  }
  depends_on  = [module.db_module]
  count       = length(local.schema_config)
  schema_name = local.schema_config[count.index].schema_name
  dbname      = local.schema_config[count.index].db_name
  retention   = local.schema_config[count.index].retention
}


module "whmodule" {
  source = "./modules/wh"
  providers = {
    snowflake = snowflake.sysadmin
  }
  for_each       = local.wh_config
  whname         = each.value.whname
  whtype         = each.value.whtype
  whsize         = each.value.whsize
  wh_autosuspend = each.value.wh_autosuspend
  wh_comment     = each.value.wh_comment
  wh_autoresume  = each.value.wh_autoresume
}


module "rolegrantsmodule" {
  source = "./modules/acc_roles_grants"
  providers = {
    snowflake = snowflake.securityadmin
  }
  depends_on       = [module.rolemodule, module.usermodule]
  for_each         = local.acc_role_config
  role_name        = each.value.role_name
  parent_role_name = each.value.parent_role_name
  user_name        = each.value.user_name
}


module "usermodule" {
  source = "./modules/user"
  providers = {
    snowflake = snowflake.useradmin
  }
  for_each   = var.users
  username   = each.value.username
  loginname  = each.value.loginname
  password   = each.value.password
  change_pwd = each.value.change_pwd
  comment    = each.value.comment
}


module "grant_role_privileges" {
  source = "./modules/acc_role_grant_privilege"
  providers = {
    snowflake = snowflake.securityadmin
  }
  depends_on    = [module.rolemodule, module.whmodule]
  for_each      = local.acc_role_config
  privileges    = each.value.wh_privileges
  acc_role_name = each.value.role_name
  object_type   = "WAREHOUSE"
  object_name   = each.value.warehouse
}


# output "name" {
#   value = local.acc_role_config
# }