region           = "ap-south-1"
key_name         = "staging-credissuer-key" 
instance_count   = 1
ami_id           = "ami-08eeffa2e01f63846" 
instance_type    = "t3a.xlarge"
public_ip        = false
volume_size      = 250
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "stage-credissuer-vault-vm"
sg_name  = "stage-credissuer-vault-vm-sg"



