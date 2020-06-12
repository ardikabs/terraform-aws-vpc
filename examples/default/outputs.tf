
output "public_subnet_ids" {
  value = module.vpc_default.public_subnet_ids
}

output "app_subnet_ids" {
  value = module.vpc_default.app_subnet_ids
}

output "data_subnet_ids" {
  value = module.vpc_default.data_subnet_ids
}

output "utility_subnet_ids" {
  value = module.vpc_default.utility_subnet_ids
}

output "intra_subnet_ids" {
  value = module.vpc_default.intra_subnet_ids
}
