output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network_skeleton.vpc_id
}

output "pub_route_table_id" {
  description = "Public route table ID"
  value       = module.network_skeleton.pub_route_table_id
}

output "pvt_route_table_id" {
  description = "Private Route table ID"
  value       = module.network_skeleton.pvt_route_table_id
}

output "db_subnet_ids" {
  value = module.network_skeleton.DBpvt_subnet_ids
}

output "app_subnet_ids" {
  value = module.network_skeleton.Apppvt_subnet_ids
}

output "public_subnet_ids" {
  value = module.network_skeleton.public_subnet_ids
}

output "vpc_cidr" {
  value = var.cidr_block
}
output "app_subnet_cidr" {
  value = var.App_private_subnets_cidr[*]
}
output "db_subnet_cidr" {
  value = var.DB_private_subnets_cidr[*]
}

output "public_subnet_cidr" {
  value = var.public_subnets_cidr[*]
}
output "mw_subnet_cidr" {
  value = var.Middleware_private_subnets_cidr[*]
}

output "mw_subnet_ids" {
  value = module.MiddlewarePrivateSubnets.ids
}