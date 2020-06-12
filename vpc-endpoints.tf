# -----------------------------
# VPC Endpoint S3 and DynamoDB
# -----------------------------

data "aws_vpc_endpoint_service" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  service = "s3"
}

data "aws_vpc_endpoint_service" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  service = "dynamodb"
}

# Provision VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this.id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
}

# Provision VPC Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.this.id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
}

# ------------------------------------
# VPCE S3 route table association
# ------------------------------------
# Create public route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  count = var.default_network && var.enable_s3_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public[0].id
}

# Create application route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_app" {
  count = var.default_network && var.enable_s3_endpoint ? length(aws_route_table.app[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.app[*].id, count.index)
}

# Create data route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_data" {
  count = var.default_network && var.enable_s3_endpoint ? length(aws_route_table.data[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.data[*].id, count.index)
}

# Create utility route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_utility" {
  count = var.default_network && var.enable_s3_endpoint ? length(aws_route_table.utility[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.utility[*].id, count.index)
}

# Create intra route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_intra" {
  count = var.default_network && var.enable_s3_endpoint ? length(aws_route_table.intra[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.intra[*].id, count.index)
}

# Create custom public route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_custom_public" {
  count = ! var.default_network && var.enable_s3_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.custom_public[0].id
}

# Create custom data private route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_custom_data" {
  count = ! var.default_network && var.enable_s3_endpoint ? length(aws_route_table.custom_data_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.custom_data_private[*].id, count.index)
}

# Create custom application private route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_custom_app" {
  count = ! var.default_network && var.enable_s3_endpoint ? length(aws_route_table.custom_app_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.custom_app_private[*].id, count.index)
}

# Create custom utility private route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_custom_utility" {
  count = ! var.default_network && var.enable_s3_endpoint ? length(aws_route_table.custom_utility_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.custom_utility_private[*].id, count.index)
}

# Create custom intra route table association with S3 VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "s3_custom_intra" {
  count = ! var.default_network && var.enable_s3_endpoint ? length(aws_route_table.custom_intra[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = element(aws_route_table.custom_intra[*].id, count.index)
}


# ------------------------------------
# VPCE DynamoDB route table association
# ------------------------------------
# Create public route table association with DyanamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_public" {
  count = var.default_network && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.public[0].id
}

# Create application route table association with DyanamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_app" {
  count = var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.app[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.app[*].id, count.index)
}

# Create data route table association with DyanamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_data" {
  count = var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.data[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.data[*].id, count.index)
}

# Create utility route table association with DyanamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_utility" {
  count = var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.utility[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.utility[*].id, count.index)
}

# Create intra route table association with DyanamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_intra" {
  count = var.default_network && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.intra[0].id
}

# Create custom public route table association with DynamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_custom_public" {
  count = ! var.default_network && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.custom_public[0].id
}

# Create custom data private route table association with DynamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_custom_data" {
  count = ! var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.custom_data_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.custom_data_private[*].id, count.index)
}

# Create custom application private route table association with DynamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_custom_app" {
  count = ! var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.custom_app_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.custom_app_private[*].id, count.index)

}

# Create custom utility private route table association with DynamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_custom_utility" {
  count = ! var.default_network && var.enable_dynamodb_endpoint ? length(aws_route_table.custom_utility_private[*]) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = element(aws_route_table.custom_utility_private[*].id, count.index)

}

# Create custom intra route table association with DynamoDB VPC Endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb_custom_intra" {
  count = ! var.default_network && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.custom_intra[0].id
}
