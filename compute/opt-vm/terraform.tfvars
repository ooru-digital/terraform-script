region           = "ap-south-1"
key_name         = "ooru-mosip-key" # Specify your key pair name here
instance_count   = 1
ami_id           = "ami-02d26659fd82cf299"
instance_type    = "t3.xlarge"
public_ip        = true
volume_size      = 128
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "credissuer-opt-vm"
sg_name  = "credissuer-opt-vm-sg"

