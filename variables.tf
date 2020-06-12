variable "module_depends_on" {
  type    = any
  default = null
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "business_unit" {
  description = "Business unit the resource belongs to"
  type        = string
}

variable "product_domain" {
  description = "A product domain the resources belongs to"
  type        = string
}

variable "tags" {
  description = "A mapping tags to be added into all resources in this modules"
  type        = map
  default     = {}
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "172.18.0.0/16"
}

variable "vpc_additional_tags" {
  description = "Additional tags to be added into VPC"
  type        = map
  default     = {}
}

variable "subnet_additional_tags" {
  description = "Additional tags to be added into all subnets"
  type        = map
  default     = {}
}

variable "public_subnet_additional_tags" {
  description = "Additional tags to be added into public subnet"
  type        = map
  default     = {}
}

variable "data_subnet_additional_tags" {
  description = "Additional tags to be added into data subnet"
  type        = map
  default     = {}
}

variable "app_subnet_additional_tags" {
  description = "Additional tags to be added into application subnet"
  type        = map
  default     = {}
}

variable "utility_subnet_additional_tags" {
  description = "Additional tags to be added into utility subnet"
  type        = map
  default     = {}
}

variable "intra_subnet_additional_tags" {
  description = "Additional tags to be added into intra subnet"
  type        = map
  default     = {}
}

variable "rds_subnet_group_name" {
  description = "RDS subnet group name"
  type = string
  default = ""
}

variable "elasticache_subnet_group_name" {
  description = "Elasticache subnet group name"
  type = string
  default = ""
}

variable "redshift_subnet_group_name" {
  description = "Redshift subnet group name"
  type = string
  default = ""
}


# ------------------------
# Default network variable
# ------------------------
variable "default_network" {
  description = "Default network setup. Change this to false, then you need your own subnet composition. Recommended value is true"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Flags for enabling S3 endpoint to the VPC. Recommended value is true"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Flags for enabling S3 endpoint to the VPC. Recommended value is true"
  type        = bool
  default     = true
}

variable "enable_rds_subnet_group" {
  description = "Enable RDS subnet group. Recommended value is true"
  type        = bool
  default     = false
}

variable "enable_elasticache_subnet_group" {
  description = "Enable Elasticache subnet group. Recommended value is true"
  type        = bool
  default     = false
}

variable "enable_redshift_subnet_group" {
  description = "Enable Redshift subnet group. Recommended value is true"
  type        = bool
  default     = false
}

# ------------------------
# Custom network variable
# ------------------------
variable "custom_subnets" {
  description = "Custom subnets composition"
  type = list(object({
    name    = string
    tier    = string
    tags    = map(string)
    subnets = list(string)
  }))
  default = []
}

variable "custom_azs" {
  description = "List of availability zones used in custom network setup"
  type        = list(string)
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c",
  ]
}

variable "enable_rds_custom_subnet_group" {
  description = "Enable RDS subnet group in custom network setup"
  type        = bool
  default     = false
}

variable "enable_elasticache_custom_subnet_group" {
  description = "Enable Elasticache subnet group in custom network setup"
  type        = bool
  default     = false
}

variable "enable_redshift_custom_subnet_group" {
  description = "Enable Redshift subnet group in custom network setup"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway custom network setup"
  type        = bool
  default     = true
}
