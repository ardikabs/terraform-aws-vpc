
output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet ids"
  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

output "app_subnet_ids" {
  description = "List of application subnet ids"
  value = [
    for subnet in aws_subnet.app :
    subnet.id
  ]
}

output "data_subnet_ids" {
  description = "List of data subnet ids"
  value = [
    for subnet in aws_subnet.data :
    subnet.id
  ]
}

output "utility_subnet_ids" {
  description = "List of utility subnet ids"
  value = [
    for subnet in aws_subnet.utility :
    subnet.id
  ]
}

output "intra_subnet_ids" {
  description = "List of intra subnet ids"
  value = [
    for subnet in aws_subnet.intra :
    subnet.id
  ]
}


output "custom_public_subnet_ids" {
  description = "List of public subnet ids on non-default network setup"
  value = [
    for subnet in aws_subnet.custom_public :
    subnet.id
  ]
}

output "custom_data_private_subnet_ids" {
  description = "List of database private subnet ids on non-default network setup"
  value = [
    for subnet in aws_subnet.custom_data_private :
    subnet.id
  ]
}

output "custom_app_private_subnet_ids" {
  description = "List of application private subnet ids on non-default network setup"
  value = [
    for subnet in aws_subnet.custom_app_private :
    subnet.id
  ]
}

output "custom_utility_private_subnet_ids" {
  description = "List of utility private subnet ids on non-default network setup"
  value = [
    for subnet in aws_subnet.custom_utility_private :
    subnet.id
  ]
}

output "custom_intra_subnet_ids" {
  description = "List of intra subnet ids on non-default network setup"
  value = [
    for subnet in aws_subnet.custom_intra :
    subnet.id
  ]
}
