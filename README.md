## Table of Content

- [Prerequisites](#Prerequisites)
- [Quick Start](#Quick-Start)
    - [Default network](#Default-network)
    - [Custom network](#Custom-network)
- [Module Definition](#Module-Definition)
    - [Providers](#Providers)
    - [Inputs](#Inputs)
    - [Outputs](#Outputs)

## Prerequisites
* [Terraform v0.12.24](https://releases.hashicorp.com/terraform/)

## Quick Start
Terraform modules which creates VPC resources on AWS.<br>
This module will help you to create a minimum VPC setup for an environment with the following resources:
* VPC
* Subnet
* Route Tables
* Internet Gateway
* NAT Gateway
* VPC Endpoints:
    * Gateway: S3, DynamoDB
* RDS Subnet Group
* ElastiCache Subnet Group
* Redshift Subnet Group

Also, this module supported with 2 kind setup which differentiate about number of subnets could be created:
#### Default network
There is 5 types of subnets created with this setup
1. Public subnet as the DMZ subnet, which only internet-facing instances is allowed to be placed.
1. Data subnet with internet-access capabilities, connected with NAT gateway per availability zones.
1. Application subnet with internet-access capabilities, connected with NAT gateway per availability zones.
1. Utility subnet with internet-access capabilities, connected with NAT gateway per availability zones.
1. Intra subnet with no internet access capabilities, only routed to the local network.

NB: This setup is our recommendation to be used on most of environment.
```hcl
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
```
#### Custom network
On the custom network setup, basically you create your own subnets composition which differentiate in 5 tier of subnet, which:
1. Public subnet (`tier = public`)
1. Data private subnet (`tier = data`)
1. Application private subnet (`tier = application`)
1. Utility private subnet (`tier = utility`)
1. Intra subnet (`tier = intranet`)

Above subnet mode, could be achieved with altered the variable `custom_subnets` such the following:
```hcl
locals {
    public_subnet = {
        name = "public"
        tier = "public" # MUST be one of public/data/application/utility/intranet
        subnets = [
            "172.18.0.0/24",
            "172.18.1.0/24",
            ...
        ]
    }

    k8s_subnet = {
        name = "kubernetes"
        tier = "application" # MUST be one of public/data/application/utility/intranet
        subnets = [
            "172.18.10.0/24",
            "172.18.11.0/24",
            ...
        ]
    }

    ...
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
    ...
  ]

  tags = {}
}

```

By default, this setup will enabled NAT gateway provisioned per availability zones. Just in case, you need to create VPC without any internet access, set variable `enable_nat_gateway` to `false` or just create with intra subnet specification.
## Module Definition

### Providers
| Name | Version |
|------|---------|
| aws | ~> 2.0.0 |

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
|module_depends_on|The modules name which this module depend on it. It is similar with `depends_on` in resources.|`any`|`null`|no|
|name|Name to be used on all the resources as identifier|`string`|n/a|yes|
|environment|An environment name|`string`|n/a|yes|
|business_unit|A business unit the resource belongs to|`string`|n/a|yes|
|product_domain|A product domain the resource belongs to|`string`|n/a|yes|
|tags|A mapping tags to be added into all resources in this modules|`map`|`{}`|no|
|vpc_additional_tags|Additional tags to be added into VPC resource under this modules|`map`|`{}`|no|
|public_subnet_additional_tags|Additional tags to be added into public subnet resources under this modules|`map`|`{}`|no|
|data_subnet_additional_tags|Additional tags to be added into data subnet resources under this modules|`map`|`{}`|no|
|app_subnet_additional_tags|Additional tags to be added into application subnet resources under this modules|`map`|`{}`|no|
|utility_subnet_additional_tags|Additional tags to be added into utility subnet resources under this modules|`map`|`{}`|no|
|intra_subnet_additional_tags|Additional tags to be added into intra subnet resources under this modules|`map`|`{}`|no|
|vpc_cidr_block|VPC CIDR Block|`string`|`"172.18.0.0/16"`|yes|
|default_network|Default network setup|`bool`|`true`|no|
|enable_s3_endpoint|Enable S3 endpoint to the VPC|`bool`|`true`|no|
|enable_dyanamodb_endpoint|Enable DynamoDB endpoint to the VPC|`bool`|`true`|no|
|enable_rds_subnet_group|Enable RDS subnet group to the VPC|`bool`|`false`|no|
|enable_elasticache_subnet_group|Enable ElastiCache endpoint to the VPC|`bool`|`false`|no|
|enable_redshift_subnet_group|Enable Redshift endpoint to the VPC|`bool`|`false`|no|
|custom_subnets|Custom network subnets composition|<pre>list(object({<br> name = string<br> tier = string<br> tags = map(string)<br> subnets = list <br>}))</pre>|n/a|yes <br>(if `default_network = false`)|
|custom_azs|Custom network availability zones|`list`|<pre>[<br>  "ap-southeast-1a",<br>  "ap-souStheast-1b",<br>  "ap-southeast-1c"<br>]<br></pre>|no|
|enable_rds_custom_subnet_group|Enable RDS subnet group to the VPC with custom network setup|`bool`|`false`|no|
|enable_elasticache_custom_subnet_group|Enable ElastiCache endpoint to the VPC with custom network setup|`bool`|`false`|no|
|enable_redshift_custom_subnet_group|Enable Redshift endpoint to the VPC with custom network setup|`bool`|`false`|no|
|enable_nat_gateway|Enable NAT gateway to the VPC with custom network setup|`bool`|`true`|no|

### Outputs
| Name | Description |
|------|-------------|
|vpc_id|VPC id|
|public_subnet_ids|List of public subnet ids|
|data_subnet_ids|List of data subnet ids|
|app_subnet_ids|List of application subnet ids|
|utility_subnet_ids|List of utility subnet ids|
|intra_subnet_ids|List of intra subnet ids|
|custom_public_subnet_ids|List of public subnet ids on non-default network setup|
|custom_data_private_subnet_ids|List of data private subnet ids on non-default network setup|
|custom_app_private_subnet_ids|List of application private subnet ids on non-default network setup|
|custom_utility_private_subnet_ids|List of utility private subnet ids on non-default network setup|
|custom_intra_subnet_ids|List of intra subnet ids on non-default network setup|