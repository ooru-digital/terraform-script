region           = "ap-south-1"
key_name         = "rdt-mosip" # Specify your key pair name here
instance_count   = 1
ami_id           = "ami-02b8269d5e85954ef"
instance_type    = "t3a.xlarge"
public_ip        = true
volume_size      = 250
volume_type      = "gp3"
encrypted_volume = false
# iam_instance_profile = "EC2ASSUMEROLEADMINACCESS"
ec2_name = "stage-credissuer-core-vm"
sg_name  = "stage-credissuer-core-vm-sg"

