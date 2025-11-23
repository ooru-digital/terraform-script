##############################
# VPC
##############################
vpc_cidr             = "10.0.0.0/16"
instance_tenancy     = "default"
enable_dns_support   = true
enable_dns_hostnames = true


##############################
# Subnets                     
##############################
subnet_names = ["public-sub-1" , "app-private-sub-1", "public-sub-2", "app-private-sub-2" ]
subnet_cidrs = ["10.0.0.0/23", "10.0.4.0/22", "10.0.6.0/24", "10.0.8.0/24"] 
subnet_azs   = ["ap-south-1a", "ap-south-1a", "ap-south-1b", "ap-south-1b"]

public_route_table    = "public-rt"
private_route_table   = "private-rt"
public_rt_cidr_block  = "0.0.0.0/0"
private_rt_cidr_block = "0.0.0.0/0"


# Use indexes for both public subnets
public_subnet_indexes = [0, 2] # index 0 = public-1, index 2 = public-2

##############################
# NACL Configuration
##############################
create_nacl = false

nacl_names = []

nacl_rules = {}


##############################
# NAT Gateway
##############################
create_nat_gateway = true
nat_gateway_count  = 1
##############################
# Flow Logs
##############################
flow_logs_enabled      = false
flow_logs_traffic_type = "ALL"
flow_logs_file_format  = "parquet"

##############################
# Route 53
##############################
create_route53 = false
route53_zone   = ""

##############################
# VPC Endpoints
##############################
enable_s3_endpoint = false
service_name_s3    = "com.amazonaws.us-east-1.s3"
s3_endpoint_type   = "Gateway"

enable_ec2_endpoint      = false
service_name_ec2         = "com.amazonaws.us-east-1.ec2"
ec2_endpoint_type        = "Interface"
ec2_endpoint_subnet_type = "public"
ec2_private_dns_enabled  = false

enable_nlb_endpoint = false
# NLB Endpoint Configuration
service_name_nlb        = "com.amazonaws.us-east-1.elasticloadbalancing"
nlb_endpoint_type       = "Interface"
nlb_private_dns_enabled = false


##############################
# Application Load Balancer
##############################
create_alb                 = false
internal                   = false
enable_deletion_protection = false
alb_certificate_arn        = ""
access_logs = {
  enabled = false
  bucket  = ""
  prefix  = ""
}

##############################
# Network Load Balancer
##############################
create_nlb  = false
is_internal = false

##############################
# Tags & Metadata
##############################
provisioner = "terraform"
tags = {
  Environment = "stage"
  Owner       = "ooru"
}

##############################
# ALB Security Group Rules
##############################
alb_ingress_rules = []

alb_egress_rules = []

##############################
# NLB Security Group Rules
##############################
nlb_ingress_rules = []

endpoint_egress_rules = []



##############################
# Key Pair Configuration
##############################
create_key_pair       = false
create_private_key    = false
key_pair_name         = ""
private_key_algorithm = "RSA"
private_key_rsa_bits  = 4096
public_key_path       = ""                                           # Leave blank if you're generating the key
key_output_dir        = "" # Directory where PEM file will be saved

env     = "stage"
owner   = "ooru"
program = "credissuer"
region  = "ap-south-1"

enable_alb_sg      = false
enable_endpoint_sg = false
enable_nlb_sg      = false


alb_listeners = []