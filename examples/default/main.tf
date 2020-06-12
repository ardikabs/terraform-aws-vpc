terraform {
  required_version = "~> 0.12.0"
}

module "vpc_default" {
  source = "../../"

  name           = "retail"
  environment    = "production"
  business_unit  = "retail"
  product_domain = "infrastructre"

  vpc_cidr_block = "172.18.0.0/16"

  default_network = true

  tags = {}
}

