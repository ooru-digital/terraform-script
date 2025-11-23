region           = "ap-south-1"
key_name         = "staging-credissuer-key" # Specify your key pair name here
instance_count   = 1
ami_id           = "ami-08a2e4090509987a1"  
instance_type    = "t3a.xlarge"
public_ip        = false
volume_size      = 128
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "stage-credissuer-opt-vm"
sg_name  = "stage-credissuer-opt-vm-sg"

