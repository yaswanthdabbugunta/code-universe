variable "resource_group_name_db" {
  type        = string
  description = "Resource Group - Database"
}

variable "resource_group_location" {
  type        = string
  description = "centralindia"
}
variable "sql_server_name" {
  type        = string
  description = "SQL Server instance name in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "SQL Database name in Azure for FT"
}



variable "sql_admin_login" {
  type        = string
  description = "SQL Server login name in Azure"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server password name in Azure"
}

