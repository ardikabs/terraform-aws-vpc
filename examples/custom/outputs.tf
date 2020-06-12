output "public_subnet_ids" {
  value = module.vpc_custom.custom_public_subnet_ids
}

output "data_private_subnet_ids" {
  value = module.vpc_custom.custom_data_private_subnet_ids
}

output "app_private_subnet_ids" {
  value = module.vpc_custom.custom_app_private_subnet_ids
}

output "utility_private_subnet_ids" {
  value = module.vpc_custom.custom_utility_private_subnet_ids
}

output "intra_subnet_ids" {
  value = module.vpc_custom.custom_intra_subnet_ids
}
