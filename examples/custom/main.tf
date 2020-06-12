locals {
  public_subnet = {
    name = "public"
    tier = "public"
    tags = {}
    subnets = [
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.3.0/24",
    ]
  }

  data_subnet = {
    name = "database"
    tier = "data"
    tags = {}
    subnets = [
      "10.0.140.0/24",
      "10.0.150.0/24",
      "10.0.160.0/24",
    ]
  }

  k8s_subnet = {
    name = "k8s"
    tier = "application"
    tags = {}
    subnets = [
      "10.0.10.0/24",
      "10.0.20.0/24",
      "10.0.30.0/24",
    ]
  }

  utility_subnet = {
    name = "utility"
    tier = "utility"
    tags = {}
    subnets = [
      "10.0.40.0/24",
      "10.0.50.0/24",
      "10.0.60.0/24",
    ]
  }

  intra_subnet = {
    name = "intra"
    tier = "intranet"
    tags = {}
    subnets = [
      "10.0.110.0/24",
      "10.0.120.0/24",
      "10.0.130.0/24",
    ]
  }

}

module "vpc_custom" {
  source = "../../"

  name           = "retail"
  environment    = "production"
  business_unit  = "retail"
  product_domain = "infrastructre"

  vpc_cidr_block = "10.0.0.0/16"

  default_network                        = false
  enable_rds_custom_subnet_group         = true
  enable_elasticache_custom_subnet_group = true
  enable_redshift_custom_subnet_group    = true

  custom_azs = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c",
  ]

  custom_subnets = [
    local.public_subnet,
    local.k8s_subnet,
    local.data_subnet,
    local.utility_subnet,
    local.intra_subnet
  ]

  tags = {}
}
