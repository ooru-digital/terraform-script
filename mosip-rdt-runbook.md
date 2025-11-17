<img width="334" height="151" alt="Mosip" src="https://github.com/user-attachments/assets/703db8be-e207-479a-bdeb-4ac4023d246b" />

# MOSIP Rapid Deployment


## Prerequisites


1. ### Cloud Provider Account (Required)

- **AWS account** with appropriate permissions (fully supported) - [How to create AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

2. ### AWS Permissions (Required)

**Essential AWS IAM permissions required for complete MOSIP deployment:**

**Core Infrastructure Services:**

- **VPC Management**: VPC, Subnets, Internet Gateways, NAT Gateways, Route Tables
- **EC2 Services**: Instance management, Security Groups, Key Pairs, EBS Volumes
- **Route 53**: DNS management, Hosted Zones, Record Sets
- **IAM**: Role creation, Policy management, Instance Profiles

**Recommended IAM Policy:**

```json
{
 "Version": "2012-10-17",
 "Statement": [
 {
 "Effect": "Allow",
 "Action": [
 "ec2:*",
 "vpc:*",
 "route53:*",
 "iam:*",
 "s3:*"
 ],
 "Resource": "*"
 }
 ]
}
```



3. ### AWS Instance Types (Required)

**Default Instance Configuration:**

- **NGINX Instance Type**: `t3a.2xlarge` ( reverse proxy)
- **Kubernetes Instance Type**: `t3a.2xlarge` (Control plane, ETCD, and worker nodes)

**Instance Family Details:**

- **t3a Instance Family**: AMD EPYC processors with burstable performance
- **2xlarge Configuration**: 8 vCPUs, 32 GiB RAM, up to 2,880 Mbps network performance




**NGINX Instance Type Recommendations:**

- **With External PostgreSQL**: `t3a.2xlarge` (recommended for PostgreSQL hosting)
- **Without External PostgreSQL**: `t3a.xlarge` or `t3a.medium` (sufficient for load balancing only)



4. ### Secrets for Rapid Deployment (Required)

> **Secret Configuration Types:**
>
> - **Repository Secrets**: Global secrets shared across all environments (set once in GitHub repo settings)
> - Think of these as "master keys" that work everywhere
> - Examples: AWS credentials, SSH keys
> - **Environment Secrets**: Environment-specific secrets (configured per deployment environment)
> - Think of these as "room keys" for specific environments
> - Examples: KUBECONFIG, WireGuard configs (different for each environment)
>

**Repository Secrets** (configured in GitHub repository settings):

```yaml
# GPG Encryption (for local backend)
GPG_PASSPHRASE: "your-gpg-passphrase" 
# What it's for: Encrypts Terraform state files to keep them secure
# How to generate: Create a strong 16+ character password
# Details: https://docs.github.com/en/actions/security-guides/encrypted-secrets
# Guide: See "GPG Passphrase" section in Secret Generation Guide

# Cloud Provider Credentials
AWS_ACCESS_KEY_ID: "AKIA..." 
# What it's for: Allows Terraform to create AWS resources
# How to get: AWS Console → IAM → Users → Security credentials → Create access key
# Details: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
# Guide: See "AWS Credentials" section in Secret Generation Guide

AWS_SECRET_ACCESS_KEY: "..." 
# What it's for: Secret key that pairs with access key ID (like a password)
# IMPORTANT: Keep this SECRET! Never commit to Git or share publicly

# SSH Private Key (must match ssh_key_name in tfvars)
YOUR_SSH_KEY_NAME: | 
# Replace YOUR_SSH_KEY_NAME with actual ssh_key_name value from your tfvars
# What it's for: Allows secure access to EC2 instances
# How to generate: ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
# Details: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# Guide: See "SSH Keys" section in Secret Generation Guide
 -----BEGIN RSA PRIVATE KEY-----
 your-ssh-private-key-content
 -----END RSA PRIVATE KEY-----
```

**Quick Secret Generation Checklist:**

- [ ] GPG Passphrase created (16+ characters)
- [ ] AWS Access Key ID obtained from IAM
- [ ] AWS Secret Access Key saved securely
- [ ] SSH key pair generated (public + private)
- [ ] SSH public key uploaded to AWS EC2 Key Pairs
- [ ] SSH private key added to GitHub secrets
- [ ] All secret names match exactly (case-sensitive!)

**Need step-by-step help?** [Secret Generation Guide](docs/SECRET_GENERATION_GUIDE.md)

**Environment Secrets** (configured per deployment environment):

```yaml
# WireGuard VPN (optional - for infrastructure access)
TF_WG_CONFIG: |
 [Interface]
 PrivateKey = terraform-private-key
 Address = 10.0.1.2/24
 
 [Peer]
 PublicKey = server-public-key
 Endpoint = your-server:51820
 AllowedIPs = 10.0.0.0/16

# Notifications (optional)
SLACK_WEBHOOK_URL: "https://hooks.slack.com/services/..." # Slack notifications
```

#### Helmsman Secrets

**Environment Secrets** (configured per deployment environment):

> **Important**: These are generated AFTER infrastructure deployment, not before!
>
> ## Next Steps & Detailed Documentation

```yaml
# Kubernetes Access
KUBECONFIG: "apiVersion: v1..." 
# What it's for: Allows Helmsman to deploy applications to your Kubernetes cluster
# When available: After Terraform infra deployment completes
# Where to find: terraform/implementations/aws/infra/kubeconfig_<cluster-name>
# Guide: See "Kubernetes Config" section in Secret Generation Guide

# WireGuard VPN Access (for cluster access)
CLUSTER_WIREGUARD_WG0: |
# What it's for: Secure VPN connection to access private Kubernetes cluster
# When available: After base-infra deployment and WireGuard setup
# How to get: Follow WireGuard setup guide
# Details: See terraform/base-infra/WIREGUARD_SETUP.md
# Guide: See "WireGuard VPN" section in Secret Generation Guide
 [Interface]
 PrivateKey = helmsman-wg0-private-key
 Address = 10.0.0.2/24
 
 [Peer]
 PublicKey = cluster-public-key
 Endpoint = cluster-server:51820
 AllowedIPs = 10.0.0.0/16

# Secondary WireGuard Config (optional)
CLUSTER_WIREGUARD_WG1: |
# Optional: Additional WireGuard peer for redundancy
 [Interface]
 PrivateKey = helmsman-wg1-private-key
 Address = 10.0.2.2/24
 
 [Peer]
 PublicKey = cluster-public-key-2
 Endpoint = cluster-server-2:51820
 AllowedIPs = 10.0.0.0/16
 ```

 ## Deployment Steps Guide

### 1. Fork and Setup Repository

```bash
# Fork the repository to your GitHub account
# Clone your fork
git clone https://github.com/YOUR_USERNAME/infra.git
cd infra
```

### 2. Configure GitHub Secrets

Navigate to your repository → **Settings** → **Secrets and variables** → **Actions**

**Configure Repository & Environment Secrets:**

Add the required secrets as follows:

- **Repository Secrets** (Settings → Secrets and variables → Actions → Repository secrets):
- `GPG_PASSPHRASE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `YOUR_SSH_KEY_NAME` (replace with actual ssh_key_name value from tfvars, e.g., `mosip-aws`)
- **Environment Secrets** (Settings → Secrets and variables → Actions → Environment secrets):
- All other secrets mentioned in the Prerequisites section above (KUBECONFIG, WireGuard configs, etc.)

<img width="732" height="267" alt="base-infra-secret" src="https://github.com/user-attachments/assets/aa0c2d2a-db7b-4433-9820-0107499860bb" />

### 3. Terraform Infrastructure Deployment



#### Understanding Terraform Apply vs Terraform Plan

| Mode                                             | What It Does                                   | When to Use                                | Visual             |
| ------------------------------------------------ | ---------------------------------------------- | ------------------------------------------ | ------------------ |
| **Terraform Plan** (checkbox unchecked ☐) | Shows what WOULD happen without making changes | Testing configurations, previewing changes | ☐ Terraform apply |
| **Apply** (checkbox checked ✅)            | Actually creates/modifies infrastructure       | Real deployments, making actual changes    | ✅ Terraform apply |



#### Step 3a: Base Infrastructure

**What this creates:**

- Virtual Private Cloud (VPC) - Your private network in AWS
- Subnets - Subdivisions of your network
- Jump Server - Secure gateway to access other servers
- WireGuard VPN - Encrypted connection to your infrastructure
- Security Groups - Firewall rules for network security


1. **Update terraform variables:**

```bash
 # Edit terraform/base-infra/aws/terraform.tfvars 
```

```bash
# AWS environment configuration values
# Created: 2025-07-24 13:05:18
# Created by: bhumi46

# Cloud provider
cloud_provider = "aws"

# Environment name
jumpserver_name = "ooru-wg-server"   # change name of wireguard vm

# Email-ID for SSL certificate notifications
mosip_email_id = "pritam.kondapratiwar@opstree.com" # change mail id 

# SSH key name for AWS instances
ssh_key_name = "rdt-mosip" # change ssh key name create new key pair for this from aws console

# AWS region
aws_provider_region = "ap-south-1"  # Change aws region name

# Jump server instance type
jumpserver_instance_type = "t3a.medium"   #Change wireguard vm type

# Jump server AMI ID (required)
jumpserver_ami_id = "ami-02d26659fd82cf299" #Change ami id it should be 22.04 ubuntu

# Whether to create an Elastic IP for the jump server
create_jumpserver_eip = false

# Network configuration
network_name       = "ooru-rdt-boxes"  --- vpc name
network_cidr       = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["ap-south-1a", "ap-south-1b"]

# Environment and project tags
environment  = "dev"
project_name = "mosip"  -- project name

# Network options
enable_nat_gateway   = true
single_nat_gateway   = true
enable_dns_hostnames = true
enable_dns_support   = true

# WireGuard automation configuration
k8s_infra_repo_url     = "https://github.com/mosip/k8s-infra.git"
k8s_infra_branch       = "develop"
wireguard_peers        = 30
enable_wireguard_setup = true
```

3. **Run base-infra via GitHub Actions:**

<img width="1170" height="106" alt="action-image" src="https://github.com/user-attachments/assets/96eb1e64-537a-438b-880e-c17636d77bc9" />
<img width="316" height="581" alt="base-infra-run-workflow" src="https://github.com/user-attachments/assets/768839ad-2bb1-4419-98e5-525b3cbdfd53" />

- ✅ Green checkmark when complete
- ✅ Infrastructure created in AWS

#### Step 3b: WireGuard VPN Setup (Required for Private Network Access)

1. **SSH to Jump Server:** Access the deployed jump server

- Use the SSH key you created earlier
- Jump server IP is in Terraform outputs

2. **Configure Peers:** Assign and customize WireGuard peer configurations

     - nevigate to /home/ubuntu/wireguard/config here
We have to create assign.txt file
```
peer1	Pritam
peer2	balpreet
peer3	bhumi
peer4	terraform
peer5	CLUSTER_WIREGUARD_WG0
peer6	CLUSTER_WIREGUARD_WG1
peer7	himaja
peer8	arpitha jain
peer9	Nidhi

```

3. **Install Client:** Set up WireGuard client on your PC/Mac

- **Windows**: [Download installer](https://www.wireguard.com/install/)
- **Mac**: Install from App Store or use `brew install wireguard-tools`
- **Linux**: `sudo apt install wireguard` (Ubuntu/Debian)


4. **Update Environment Secrets:** Add WireGuard configurations to your GitHub environment secrets:

- `TF_WG_CONFIG` - For Terraform infrastructure deployments
- `CLUSTER_WIREGUARD_WG0` - For Helmsman cluster access (peer1)
- `CLUSTER_WIREGUARD_WG1` - For Helmsman cluster access (peer2, optional)

<img width="706" height="403" alt="env-secrete" src="https://github.com/user-attachments/assets/5f694ad5-66d1-490a-941c-67dd3ea4865e" />

#### Step 3c: MOSIP Infrastructure

This step creates MOSIP Kubernetes cluster, PostgreSQL (if enabled), networking, and application infrastructure

1. **Update infra variables in `terraform/implementations/aws/infra/aws.tfvars`:**

```bash
# Environment name (infra component)
cluster_name = "oorucluster"  # --- Change cluster name
# MOSIP's domain (ex: sandbox.xyz.net)
cluster_env_domain = "testrdt.credissuer.com" # --- Change domain name  
# Email-ID will be used by certbot to notify SSL certificate expiry via email
mosip_email_id = "pritam.kondapratiwar@opstree.com" # Change email id
# SSH login key name for AWS node instances (ex: my-ssh-key)
ssh_key_name = "rdt-mosip"  # --- Change ssh key name
# The AWS region for resource creation
aws_provider_region = "ap-south-1"  #--- Change  region name

# Specific availability zones for VM deployment (optional)
# If empty, uses all available AZs in the region
# Example: ["ap-south-1a", "ap-south-1b"] for specific AZs
# Example: [] for all available AZs in the region
specific_availability_zones = ["ap-south-1b"]  #--- Change az

# The instance type for Kubernetes nodes (control plane, worker, etcd)
k8s_instance_type = "t3a.2xlarge"  #--- Change instance_type
# The instance type for Nginx server (load balancer)
nginx_instance_type = "t3a.2xlarge"
# The Route 53 hosted zone ID
zone_id = "Z07357392EQQ8SHT1714S"  # --- Change zone id

## UBUNTU 24.04
# The Amazon Machine Image ID for the instances
ami = "ami-0ad21ae1d0696ad58" # Change OS version Ubuntu 22.04 LTS AMI ID for ap-south-1

# Repo K8S-INFRA URL
k8s_infra_repo_url = "https://github.com/mosip/k8s-infra.git"
# Repo K8S-INFRA branch
k8s_infra_branch = "v1.2.1.0"
# NGINX Node's Root volume size
nginx_node_root_volume_size = 24
# NGINX node's EBS volume size
nginx_node_ebs_volume_size = 300
# NGINX node's second EBS volume size (optional - set to 0 to disable)
nginx_node_ebs_volume_size_2 = 200 # Enable second EBS volume for PostgreSQL testing
# Kubernetes nodes Root volume size
k8s_instance_root_volume_size = 64

# Control-plane, ETCD, Worker
k8s_control_plane_node_count = 3
# ETCD, Worker
k8s_etcd_node_count = 3
# Worker
k8s_worker_node_count = 2

# RKE2 Version Configuration
rke2_version = "v1.28.9+rke2r1"

# Security group CIDRs
network_cidr   = "10.0.0.0/8" # Use your actual VPC CIDR
WIREGUARD_CIDR = "10.0.0.0/8" # Use your actual WireGuard VPN CIDR


# Rancher Import URL
# Rancher Import Configuration
enable_rancher_import = false
rancher_import_url    = "\"kubectl apply -f https://rancher.observation.mosip.net/v3/import/b94jcxqdddb9k9p7rj4kzf4c7xkkqnvrz886wx9pf44btvwjs5bnzt_c-m-flzdgnth.yaml\""
# DNS Records to map
subdomain_public   = ["resident", "prereg", "esignet", "healthservices", "signup"]
subdomain_internal = ["admin", "iam", "activemq", "kafka", "kibana", "postgres", "smtp", "pmp", "minio", "regclient", "compliance"]

# PostgreSQL Configuration (used when second EBS volume is enabled)
enable_postgresql_setup = true # Enable PostgreSQL setup for main infra
postgresql_version      = "15"
storage_device          = "/dev/nvme2n1"
mount_point             = "/srv/postgres"
postgresql_port         = "5433"

# MOSIP Infrastructure Repository Configuration
mosip_infra_repo_url = "https://github.com/mosip/infra.git"

mosip_infra_branch = "v0.1.0-beta.1"


# VPC Configuration - Existing VPC to use (discovered by Name tag)
vpc_name = "ooru-rdt-boxes"  # --- Change vpc name
```

 **Key Configuration Variables Explained:**

| Variable                         | Description                                | Example Value                               |
| -------------------------------- | ------------------------------------------ | ------------------------------------------- |
| `cluster_name`                 | Unique identifier for your MOSIP cluster   | `"soil38"`                                |
| `cluster_env_domain`           | Domain name for MOSIP services access      | `"soil38.mosip.net"`                      |
| `mosip_email_id`               | Email for SSL certificate notifications    | `"admin@example.com"`                     |
| `ssh_key_name`                 | AWS EC2 key pair name for SSH access       | `"mosip-aws"`                             |
| `aws_provider_region`          | AWS region for resource deployment         | `"ap-south-1"`                            |
| `zone_id`                      | Route 53 hosted zone ID for DNS management | `"Z090954828SJIEL6P5406"`                 |
| `k8s_instance_type`            | EC2 instance type for Kubernetes nodes     | `"t3a.2xlarge"`                           |
| `nginx_instance_type`          | EC2 instance type for load balancer        | `"t3a.2xlarge"`                           |
| `ami`                          | Amazon Machine Image ID (Ubuntu 24.04)     | `"ami-0ad21ae1d0696ad58"`                 |
| `enable_postgresql_setup`      | External PostgreSQL setup via Terraform    | `true` (external) / `false` (container) |
| `nginx_node_ebs_volume_size_2` | EBS volume size for PostgreSQL data (GB)   | `200`                                     |
| `postgresql_version`           | PostgreSQL version to install              | `"15"`                                    |
| `postgresql_port`              | PostgreSQL service port                    | `"5433"`                                  |
| `vpc_name`                     | Existing VPC name tag to use               | `"mosip-boxes"`                           |



#### Rancher Import Configuration (Optional)

If you have deployed **observ-infra** (Rancher management cluster), you can import your main infra cluster into Rancher for centralized monitoring and management.

**Step 1: Generate Rancher Import URL**

1. **Access Rancher UI:**

   ```
   https://rancher.your-domain.net
   ```

   Login with credentials from observ-infra deployment.
2. **Navigate to Cluster Import:**

   ```
   Rancher UI → Cluster Management → Import Existing
   ```
3. **Select Import Method:**

   ```
   Cluster Name: soil38 (use your cluster_name from aws.tfvars)

   Click: "Create"
   ```
5. **Copy the kubectl apply command:**

   Rancher will generate a command like:

   ```bash
   kubectl apply -f https://rancher.mosip.net/v3/import/dzshvnb6br7qtf267zsrr9xsw6tnb2vt4x68g79r2wzsnfgvkjq2jk_c-m-b5249w76.yaml
   ```

**Step 2: Update aws.tfvars**

Add the generated command to your `aws.tfvars` file:

```hcl
# Enable Rancher import
enable_rancher_import = true

# Paste the kubectl apply command from Rancher UI
# IMPORTANT: Use proper escaping - wrap the entire command in quotes with escaped inner quotes
rancher_import_url = "\"kubectl apply -f https://rancher.mosip.net/v3/import/dzshvnb6br7qtf267zsrr9xsw6tnb2vt4x68g79r2wzsnfgvkjq2jk_c-m-b5249w76.yaml\""
```
**⚠️ Critical: Proper String Escaping**

The `rancher_import_url` requires special escaping to avoid Terraform indentation errors:

✅ **Correct format:**

```hcl
rancher_import_url = "\"kubectl apply -f https://rancher.example.com/v3/import/TOKEN.yaml\""
```

❌ **Wrong format (will cause errors):**

```hcl
rancher_import_url = "kubectl apply -f https://rancher.example.com/v3/import/TOKEN.yaml"
```
**Step 3: Deploy/Update Main Infra**

After updating `aws.tfvars`, deploy or update your main infra cluster:
<img width="1170" height="106" alt="action-image" src="https://github.com/user-attachments/assets/f966b47e-6f63-4d88-9b89-688fe8adfd20" />

<img width="267" height="575" alt="infra-workflow" src="https://github.com/user-attachments/assets/85f819fa-e81d-485a-92ea-bef5ea73bb37" />

<img width="954" height="367" alt="image" src="https://github.com/user-attachments/assets/5e7be81d-0a02-47d9-baca-81c161a3139f" />

- **After the successful completion of the infra job, a file will be automatically created in the terraform/implementations/aws/infra directory (file name: oorucluster-CONTROL-PLANE-NODE-1.yaml).**
- **Export this kubeconfig file on your local machine to access the MOSIP cluster.**
- 
```bash
#Note: Ensure that WireGuard is connected.
```

<img width="851" height="185" alt="image1" src="https://github.com/user-attachments/assets/9789343c-f719-476d-9405-9271bd7f29e7" />

### 4. Helmsman Deployment
#### Step 4a: Update DSF Configuration Files
1. **Navigate to DSF configuration directory:**

```bash
 cd infra/Helmsman/dsf
```

2. **Update prereq-dsf.yaml:**


- #### Replace  <sandbox> ---> your cluster domain that you have changed in terraform/implementations/aws/infra/aws.tfvars ie, testrdt
<img width="824" height="42" alt="image2" src="https://github.com/user-attachments/assets/195956bf-35c6-43f8-9147-4ad2f6068e9f" />

- #### Replace  sandbox.xyz.net ---->  your cluster domain that you have changed in terraform/implementations/aws/infra/aws.tfvars ie, testrdt.credissuer.com 
<img width="835" height="61" alt="image3" src="https://github.com/user-attachments/assets/260a3d65-8976-43e8-a8da-b923ea735e04" />


3. **Update external-dsf.yaml::**

- 1. **Create reCAPTCHA keys for each domain:**

- Go to [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin/create)
- Create reCAPTCHA v2 ("I'm not a robot" Checkbox) for each domain:
- **PreReg domain**: `prereg.your-domain.net` (e.g., `prereg.soil.mosip.net`)
- **Admin domain**: `admin.your-domain.net` (e.g., `admin.soil.mosip.net`)
- **Resident domain**: `resident.your-domain.net` (e.g., `resident.soil.mosip.net`)

2. **Update captcha-setup.sh arguments in external-dsf.yaml (around line 303):**

```yaml
 hooks:
 postInstall: "$WORKDIR/hooks/captcha-setup.sh PREREG_SITE_KEY PREREG_SECRET_KEY ADMIN_SITE_KEY ADMIN_SECRET_KEY RESIDENT_SITE_KEY RESIDEN
 ```

 

3. ***Replace  sandbox.xyz.net ---->  your cluster domain that you have changed in terraform/implementations/aws/infra/aws.tfvars ie, testrdt.credissuer.com***

| Key | Value |
|-----|--------|
| postgresHost | postgres.testrdt.credissuer.com |
| databases.mosip_master.host | postgres.testrdt.credissuer.com |
| databases.mosip_audit.host | postgres.testrdt.credissuer.com |
| databases.mosip_keymgr.host | postgres.testrdt.credissuer.com |
| databases.mosip_kernel.host | postgres.testrdt.credissuer.com |
| databases.mosip_idmap.host | postgres.testrdt.credissuer.com |
| databases.mosip_prereg.host | postgres.testrdt.credissuer.com |
| databases.mosip_idrepo.host | postgres.testrdt.credissuer.com |
| databases.mosip_ida.host | postgres.testrdt.credissuer.com |
| databases.mosip_credential.host | postgres.testrdt.credissuer.com |
| databases.mosip_regprc.host | postgres.testrdt.credissuer.com |
| databases.mosip_pms.host | postgres.testrdt.credissuer.com |
| databases.mosip_hotlist.host | postgres.testrdt.credissuer.com |
| databases.mosip_resident.host | postgres.testrdt.credissuer.com |
| databases.mosip_otp.host | postgres.testrdt.credissuer.com |
| databases.mosip_digitalcard.host | postgres.testrdt.credissuer.com |
| keycloakExternalHost | iam.testrdt.credissuer.com |
| keycloak.realms.mosip.realm_config.attributes.frontendUrl | https://iam.testrdt.credissuer.com/auth |
| externalHost | minio.testrdt.credissuer.com |
| istio.hosts[0] | activemq.testrdt.credissuer.com |
| kafkaUiHost | kafka.testrdt.credissuer.com |
| landing.version | develop |
| landing.name | testrdt |
| landing.api | api.testrdt.credissuer.com |
| landing.apiInternal | api-internal.testrdt.credissuer.com |
| landing.admin | admin.testrdt.credissuer.com |
| landing.prereg | prereg.testrdt.credissuer.com |
| landing.kafka | kafka.testrdt.credissuer.com |
| landing.kibana | kibana.testrdt.credissuer.com |
| landing.activemq | activemq.testrdt.credissuer.com |
| landing.minio | minio.testrdt.credissuer.com |
| landing.keycloak | iam.testrdt.credissuer.com |
| landing.regclient | regclient.testrdt.credissuer.com |
| landing.postgres.host | postgres.testrdt.credissuer.com |
| landing.postgres.port | 5433 |
| landing.compliance | compliance.testrdt.credissuer.com |
| landing.pmp | pmp.testrdt.credissuer.com |
| landing.resident | resident.testrdt.credissuer.com |
| landing.esignet | esignet.testrdt.credissuer.com |
| landing.smtp | smtp.testrdt.credissuer.com |
| landing.healthservices | healthservices.testrdt.credissuer.com |
| landing.injiweb | injiweb.testrdt.credissuer.com |
| landing.injiverify | injiverify.testrdt.credissuer.com |
| istio.host | testrdt.mosip.net |

4. **Update mosip-dsf.yaml:**


-  **Replace  sandbox.xyz.net ---->  your cluster domain that you have changed in terraform/implementations/aws/infra/aws.tfvars ie, testrdt.credissuer.com**

- **Update the module boolen value in mosip-dsf.yaml**

<img width="665" height="522" alt="image4" src="https://github.com/user-attachments/assets/cfc6bdd3-4b6f-47b2-a9b3-1377f6d0fac1" />

- **Update the relica count in mosip-dsf.yaml**

<img width="1004" height="542" alt="image5" src="https://github.com/user-attachments/assets/988ef3e7-df0d-46ac-b617-d3b41e21377f" />
.
<img width="1004" height="542" alt="image6" src="https://github.com/user-attachments/assets/4720f5cc-aed3-4a73-a17d-f0e3952cd381" />

5. **Update testrigs-dsf.yaml (if deploying test environment):**
-  **Replace  sandbox.xyz.net ---->  your cluster domain that you have changed in terraform/implementations/aws/infra/aws.tfvars ie, testrdt.credissuer.com**


6. **Update config-server-values.yaml which is present inside the Helmsman/utils/**
-  There is **v** missing here 1.2.4.3-beta it should be v1.2.4.3-beta
<img width="1026" height="243" alt="image7" src="https://github.com/user-attachments/assets/8659894d-d0f9-44a9-a6a9-3b3b15dc0e25" />

7. **Update global_configmap.yaml which is present inside the Helmsman/utils/**
-  **Replace  mosip.net ---->  your cluster domain i.e,credissuer.com**
<img width="1000" height="473" alt="image8" src="https://github.com/user-attachments/assets/4a18c520-d8c0-4e1e-962e-7b87d7416873" />


#### Step 4b: Configure Repository Secrets for Helmsman

**After updating all DSF files**, configure the required repository secrets for Helmsman deployments:

1. **Update Repository Branch Configuration:**

- Ensure your repository is configured to use the correct branch for Helmsman workflows
- Verify GitHub Actions have access to your deployment branch

2. **Configure KUBECONFIG Secret:**

 **Locate the Kubernetes config file:**

```bash
 # After Terraform infrastructure deployment completes, find the kubeconfig file in:
 terraform/implementations/aws/infra/
```

**Example kubeconfig file location:**

```
 terraform/implementations/aws/infra/kubeconfig_<cluster-name>
 terraform/implementations/aws/infra/<cluster-name>-role.yaml
```

 **Add KUBECONFIG as Environment Secret:**

- Go to your GitHub repository → Settings → Environments

- Click "Add secret" under Environment secrets
- Name: `KUBECONFIG`
- Value: Copy the entire contents of the kubeconfig file from `terraform/implementations/aws/infra/`



3. **Required Environment Secrets for Helmsman:**

 **Environment Secrets (branch-specific):**

```yaml
 # Kubernetes Access (Environment Secret)
 KUBECONFIG: "<contents-of-kubeconfig-file>"

 # WireGuard Cluster Access for Helmsman
 CLUSTER_WIREGUARD_WG0: "peer1-wireguard-config" # Helmsman cluster access (peer1)
 CLUSTER_WIREGUARD_WG1: "peer2-wireguard-config" # Helmsman cluster access (peer2)
```

4. **Verify Secret Configuration:**

- Ensure KUBECONFIG is configured as environment secret for your branch
- Verify repository secrets are properly configured
- Test repository access from GitHub Actions
- Verify KUBECONFIG provides cluster access

<img width="706" height="403" alt="image9" src="https://github.com/user-attachments/assets/3460d71f-f582-49ee-a5ac-073c609b5c16" />


#### Step 4c: Run Helmsman Deployments via GitHub Actions
- **(1)** Actions → **"Deploy External services of mosip using Helmsman"** (or "Helmsman External Dependencies")
  - **Can't find it?** Search for "External" in the workflows list
- **(2)** **Select Run workflow**
- **(3)** **Select Branch**
- This workflow handles both deployments in parallel:
  - **Prerequisites**: `prereq-dsf.yaml` (monitoring, Istio, logging)
  - **External Dependencies**: `external-dsf.yaml` (databases, message queues, storage)
- **(4)** **Mode**: `apply` (required - dry-run will fail!)
  - **Important:** DO NOT select dry-run mode for Helmsman
  - **Time required:** 20-40 minutes
  - **Automatic Trigger**: Upon successful completion, this workflow automatically triggers the MOSIP services deployment


<img width="1008" height="318" alt="image10" src="https://github.com/user-attachments/assets/b3d900ec-b45c-43f4-9d0a-0fcee6f08c5d" />


2. **Deploy MOSIP Services (Automated):**

- **Automatically triggered** after successful completion of step 1
- Workflow: **Deploy MOSIP services using Helmsman** (`helmsman_mosip.yml`)
- DSF file: `mosip-dsf.yaml`
- Mode: `apply` (required - dry-run will fail due to namespace dependencies)

<img width="1294" height="305" alt="image11" src="https://github.com/user-attachments/assets/ac9a34e3-c38f-431e-afe9-a29db30f6041" />


5. **Deploy Test Rigs (Manual):**

- **Prerequisites**: All pods from steps 1-2 must be in `Running` state and onboarding completed successfully
- **(1)** Actions → **Deploy Testrigs of mosip using Helmsman** (`helmsman_testrigs.yml`)
- **(2)** workflow - **select Run workflow in right side**
- **(3)** Branch - **Select Branch**
- **(4)** Mode: `apply` (required - dry-run will fail due to namespace dependencies)

**Post-Deployment Steps:**

After test rigs deployment completes:

1. **Update cron schedules**: Update the cron time for all CronJobs in the `dslrig`, `apitestrig`, and `uitestrig` namespaces as needed
2. **Trigger DSL orchestrator**:

   ```bash
   kubectl create job --from=cronjob/cronjob-dslorchestrator-full dslrig-manual-run -n dslrig
   ```

   > **Note**: This job will run for more than 3 hours. Monitor progress with:
   >
   > ```bash
   > kubectl logs -f job/dslrig-manual-run -n dslrig
   > ```
   >

### 6. Verify Deployment

```bash
# Check cluster status
kubectl get nodes
kubectl get namespaces

# Check MOSIP services
kubectl get pods -A
kubectl get services -n istio-system
```

---


- Access the cluster and proceed accordingly.
 kubectl get cronjob -n apitestrig
```bash
 kubectl get cronjob -n apitestrig
```
```bash
cronjob-apitestrig-auth: 05 20 * * 0-4
cronjob-apitestrig-idrepo: 45 21 * * 0-4
cronjob-apitestrig-masterdata * * 0-4
cronjob-apitestrig-partner: 05 22 * * 0-4
cronjob-apitestrig-prereg: 20 22 * * 0-5
cronjob-apitestrig-resident: 0 0 * * 1-5
```

```bash
kubectl edit cronjob -n dslrig
```
- We have made changes to the schedule, and there are multiple places where updates were applied.”
<img width="492" height="62" alt="image12" src="https://github.com/user-attachments/assets/8ded95af-2440-43c4-a3c0-21f43d4be576" />


```
30 15 * * 0-4
```

<img width="298" height="85" alt="image13" src="https://github.com/user-attachments/assets/1123927f-828d-4a50-b4ac-66df153a01ba" />