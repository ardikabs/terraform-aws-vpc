locals {
  custom_public_subnets = flatten([
    for item in var.custom_subnets : [
      for subnet in item.subnets : {
        name   = item.name
        tags   = item.tags
        subnet = subnet
      } if item.tier == "public"
    ]
  ])

  custom_data_private_subnets = flatten([
    for item in var.custom_subnets : [
      for subnet in item.subnets : {
        name   = item.name
        tags   = item.tags
        subnet = subnet
      } if item.tier == "data"
    ]
  ])

  custom_app_private_subnets = flatten([
    for item in var.custom_subnets : [
      for subnet in item.subnets : {
        name   = item.name
        tags   = item.tags
        subnet = subnet
      } if item.tier == "application"
    ]
  ])

  custom_utility_private_subnets = flatten([
    for item in var.custom_subnets : [
      for subnet in item.subnets : {
        name   = item.name
        tags   = item.tags
        subnet = subnet
      } if item.tier == "utility"
    ]
  ])

  custom_intra_subnets = flatten([
    for item in var.custom_subnets : [
      for subnet in item.subnets : {
        name   = item.name
        subnet = subnet
      } if item.tier == "intranet"
    ]
  ])
}

# Provision custom public subnet
resource "aws_subnet" "custom_public" {
  count = ! var.default_network ? length(local.custom_public_subnets) : 0

  tags = merge(
    local.common_tags,
    element(local.custom_public_subnets[*].tags, count.index),
    map("Name", lower(format("%s-%s-subnet", var.name, element(local.custom_public_subnets[*].name, count.index)))),
    map("Tier", "public"),
  )

  vpc_id = aws_vpc.this.id

  cidr_block           = local.custom_public_subnets[count.index].subnet
  availability_zone    = length(regexall("^[a-z]{2}-.+-[0-9][a-z]$", element(var.custom_azs, count.index))) > 0 ? element(var.custom_azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-.+-[0-9][a-z]$", element(var.custom_azs, count.index))) == 0 ? element(var.custom_azs, count.index) : null
}

# Provision custom data private subnet
resource "aws_subnet" "custom_data_private" {
  count = ! var.default_network ? length(local.custom_data_private_subnets) : 0

  tags = merge(
    local.common_tags,
    element(local.custom_data_private_subnets[*].tags, count.index),
    map("Name", lower(format("%s-%s-subnet", var.name, element(local.custom_data_private_subnets[*].name, count.index)))),
    map("Tier", "data"),
  )

  vpc_id = aws_vpc.this.id

  cidr_block           = local.custom_data_private_subnets[count.index].subnet
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) > 0 ? element(var.custom_azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) == 0 ? element(var.custom_azs, count.index) : null
}

# Provision custom application private subnet
resource "aws_subnet" "custom_app_private" {
  count = ! var.default_network ? length(local.custom_app_private_subnets) : 0

  tags = merge(
    local.common_tags,
    element(local.custom_app_private_subnets[*].tags, count.index),
    map("Name", lower(format("%s-%s-subnet", var.name, element(local.custom_app_private_subnets[*].name, count.index)))),
    map("Tier", "application"),
  )

  vpc_id = aws_vpc.this.id

  cidr_block           = local.custom_app_private_subnets[count.index].subnet
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) > 0 ? element(var.custom_azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) == 0 ? element(var.custom_azs, count.index) : null
}

# Provision custom utility private subnet
resource "aws_subnet" "custom_utility_private" {
  count = ! var.default_network ? length(local.custom_utility_private_subnets) : 0

  tags = merge(
    local.common_tags,
    element(local.custom_utility_private_subnets[*].tags, count.index),
    map("Name", lower(format("%s-%s-subnet", var.name, element(local.custom_utility_private_subnets[*].name, count.index)))),
    map("Tier", "utility"),
  )

  vpc_id = aws_vpc.this.id

  cidr_block           = local.custom_utility_private_subnets[count.index].subnet
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) > 0 ? element(var.custom_azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) == 0 ? element(var.custom_azs, count.index) : null
}

# Provision custom intra subnet
resource "aws_subnet" "custom_intra" {
  count = ! var.default_network ? length(local.custom_intra_subnets) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-%s-subnet", var.name, element(local.custom_intra_subnets[*].name, count.index)))),
    map("Tier", "intranet"),
  )

  vpc_id = aws_vpc.this.id

  cidr_block           = local.custom_intra_subnets[count.index].subnet
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) > 0 ? element(var.custom_azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.custom_azs, count.index))) == 0 ? element(var.custom_azs, count.index) : null
}


# Provision RDS subnet groups
# RDS subnet groups associated with custom private subnet
resource "aws_db_subnet_group" "custom_rds_subnet_group" {
  count = ! var.default_network && var.enable_rds_custom_subnet_group && length(local.custom_data_private_subnets) > 0 ? 1 : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-default-rds-subnet-group", var.name))),
    map("Tier", "data"),
  )

  name       = lower(format("%s-default-rds-subnet-group", var.name))
  subnet_ids = aws_subnet.custom_data_private[*].id

  lifecycle {
    ignore_changes = [
      id
    ]
  }
}

# Provision Elasticache subnet groups
# Elasticache subnet groups associated with custom private subnet
resource "aws_elasticache_subnet_group" "custom_elasticache_subnet_group" {
  count = ! var.default_network && var.enable_elasticache_custom_subnet_group && length(local.custom_data_private_subnets) > 0 ? 1 : 0

  name       = lower(format("%s-default-elasticache-subnet-group", var.name))
  subnet_ids = aws_subnet.custom_data_private[*].id

  lifecycle {
    ignore_changes = [
      id
    ]
  }
}

# Provision Redshift subnet groups
# Redshift subnet groups associated with custom private subnet
resource "aws_redshift_subnet_group" "custom_redshift_subnet_group" {
  count = ! var.default_network && var.enable_redshift_custom_subnet_group && length(local.custom_data_private_subnets) > 0 ? 1 : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-default-redshift-subnet-group", var.name))),
    map("Tier", "data"),
  )

  name       = lower(format("%s-default-redshift-subnet-group", var.name))
  subnet_ids = aws_subnet.custom_data_private[*].id

  lifecycle {
    ignore_changes = [
      id
    ]
  }
}


# Provision Elastic IPs for NAT gateway
resource "aws_eip" "custom_eip_nat" {
  count = ! var.default_network && var.enable_nat_gateway ? length(var.custom_azs) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-natgw-eip", var.name))),
    map("Tier", "nat-gateway"),
  )

  vpc = true
}

resource "aws_nat_gateway" "custom_natgw" {
  depends_on = [
    aws_internet_gateway.this,
    aws_eip.custom_eip_nat
  ]

  count = ! var.default_network && var.enable_nat_gateway ? length(var.custom_azs) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-natgw", var.name))),
    map("Tier", "nat-gateway"),
  )

  allocation_id = element(aws_eip.custom_eip_nat[*].id, count.index)
  subnet_id     = element(aws_subnet.custom_public[*].id, count.index)
}

# -----------------
# Public route
# -----------------

# Provision custom public route table for internet-access
resource "aws_route_table" "custom_public" {
  count = ! var.default_network ? 1 : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-public-routetable", var.name))),
    map("Tier", "public"),
  )

  vpc_id = aws_vpc.this.id
}

resource "aws_route" "custom_public" {
  count = ! var.default_network && length(local.custom_public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.custom_public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Provision custom public route table association
resource "aws_route_table_association" "custom_public" {
  count = ! var.default_network && length(local.custom_public_subnets) > 0 ? length(aws_subnet.custom_public[*].id) : 0

  subnet_id      = element(aws_subnet.custom_public[*].id, count.index)
  route_table_id = aws_route_table.custom_public[0].id
}

# -----------------
# data route
# -----------------

# Provision custom data private route table for internet-access
resource "aws_route_table" "custom_data_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-data-routetable", var.name))),
    map("Tier", "data"),
  )

  vpc_id = aws_vpc.this.id
}

resource "aws_route" "custom_data_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  route_table_id         = element(aws_route_table.custom_data_private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.custom_natgw[*].id, count.index)
}

# Provision custom application private route table association
resource "aws_route_table_association" "custom_data_private" {
  count = ! var.default_network && var.enable_nat_gateway && length(local.custom_data_private_subnets) > 0 ? length(aws_subnet.custom_data_private[*].id) : 0

  subnet_id      = element(aws_subnet.custom_data_private[*].id, count.index)
  route_table_id = element(aws_route_table.custom_data_private[*].id, count.index)
}

# -----------------
# Application route
# -----------------

# Provision custom application private route table for internet-access
resource "aws_route_table" "custom_app_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-app-routetable", var.name))),
    map("Tier", "application"),
  )

  vpc_id = aws_vpc.this.id
}

resource "aws_route" "custom_app_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  route_table_id         = element(aws_route_table.custom_app_private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.custom_natgw[*].id, count.index)
}

# Provision custom application private route table association
resource "aws_route_table_association" "custom_app_private" {
  count = ! var.default_network && var.enable_nat_gateway && length(local.custom_app_private_subnets) > 0 ? length(aws_subnet.custom_app_private[*].id) : 0

  subnet_id      = element(aws_subnet.custom_app_private[*].id, count.index)
  route_table_id = element(aws_route_table.custom_app_private[*].id, count.index)
}

# -----------------
# utility route
# -----------------

# Provision custom utility private route table for internet-access
resource "aws_route_table" "custom_utility_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-utility-routetable", var.name))),
    map("Tier", "utility"),
  )

  vpc_id = aws_vpc.this.id
}

resource "aws_route" "custom_utility_private" {
  count = ! var.default_network && var.enable_nat_gateway ? length(aws_nat_gateway.custom_natgw) : 0

  route_table_id         = element(aws_route_table.custom_utility_private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.custom_natgw[*].id, count.index)
}

# Provision custom utility private route table association
resource "aws_route_table_association" "custom_utility_private" {
  count = ! var.default_network && var.enable_nat_gateway && length(local.custom_utility_private_subnets) > 0 ? length(aws_subnet.custom_utility_private[*].id) : 0

  subnet_id      = element(aws_subnet.custom_utility_private[*].id, count.index)
  route_table_id = element(aws_route_table.custom_utility_private[*].id, count.index)
}

# -----------------
# Intra route
# -----------------

# Provision custom intra route table for internet-access
resource "aws_route_table" "custom_intra" {
  count = ! var.default_network ? 1 : 0

  tags = merge(
    local.common_tags,
    map("Name", lower(format("%s-intra-routetable", var.name))),
    map("Tier", "intranet"),
  )

  vpc_id = aws_vpc.this.id
}

# Provision custom intra route table association
resource "aws_route_table_association" "custom_intra" {
  count = ! var.default_network && length(local.custom_intra_subnets) > 0 ? length(aws_subnet.custom_intra[*].id) : 0

  subnet_id      = element(aws_subnet.custom_intra[*].id, count.index)
  route_table_id = aws_route_table.custom_intra[0].id
}
