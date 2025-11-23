output "instance_ip" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2_instance[*].private_ip
}

output "instance_id" {
  description = "IDs of the EC2 instances"
  value       = module.ec2_instance[*].instance_id
}

output "core_vm_sg" {
  description = "SG IDs of the EC2 instances"
  value       = module.core_vm_sg.sg_id
}
