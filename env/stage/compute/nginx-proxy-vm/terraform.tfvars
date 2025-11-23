region           = "ap-south-1"
key_name         = "staging-credissuer-key" 
instance_count   = 1
ami_id           = "ami-02b8269d5e85954ef" 
instance_type    = "c5a.xlarge"  
public_ip        = true
volume_size      = 20
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "stage-credissuer-nginx-proxy-vm"
sg_name  = "stage-credissuernginx-proxy-vm-sg"

