variable "sf_org" {
  type    = string
  default = "***"
}

variable "sf_acc" {
  type    = string
  default = "***"
}

variable "sf_private_key_path" {
  type    = string
  default = "../keys/k1/snowflake_tf_snow_key.p8" ## This key path is in my local.
}

# variable "user1" {
#   type = map(any)
#   default = {
#     "username"   = "tf_user_1"
#     "loginname"  = "tf_user_1"
#     "comment"    = "This is first user"
#     "password"   = "Tf_user_1234567890"
#     "change_pwd" = true
#   }
# }

variable "db_list" {
  type = map(object({
    retention    = number
    comment      = string
    is_transient = bool
  }))
  default = {
    "dev" = {
      comment      = "This is dev DB"
      retention    = 10
      is_transient = false
    }

    "prod" = {
      comment      = "This is prod DB"
      retention    = 20
      is_transient = false
    }
  }
}


variable "wh_list" {
  type = map(object({
    whtype         = string
    whsize         = string
    wh_autosuspend = number
    wh_autoresume  = bool
    wh_comment     = string
  }))
  default = {
    "dev" = {
      whtype         = "STANDARD"
      whsize         = "XSMALL"
      wh_autosuspend = 60
      wh_autoresume  = false
      wh_comment     = "THIS WAREHOUSE IS FOR DEV DATABASE"
    }

    "prod" = {
      whtype         = "STANDARD"
      whsize         = "MEDIUM"
      wh_autosuspend = 300
      wh_autoresume  = true
      wh_comment     = "THIS WAREHOUSE IS FOR PROD DATABASE"
    }
  }
}


variable "users" {
  type = map(object({
    username   = string
    loginname  = string
    comment    = string
    password   = string
    change_pwd = bool
  }))
  default = {
    "user1" = {
      "username"   = "tf_user_1"
      "loginname"  = "tf_user_1"
      "comment"    = "This is first user"
      "password"   = "Tf_user1_1234567890"
      "change_pwd" = false
    }

    "user2" = {
      "username"   = "tf_user_2"
      "loginname"  = "tf_user_2"
      "comment"    = "This is second user"
      "password"   = "Tf_user2_1234567890"
      "change_pwd" = true
    }
  }
}