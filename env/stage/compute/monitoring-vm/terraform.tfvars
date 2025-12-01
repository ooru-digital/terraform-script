region           = "ap-south-1"
key_name         = "staging-credissuer-key" 
instance_count   = 1
ami_id           = "ami-02b8269d5e85954ef" 
instance_type    = "c5a.xlarge"
public_ip        = false
volume_size      = 200
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "stage-monitoring-vm"
sg_name  = "stage-monitoring-vm-sg"



