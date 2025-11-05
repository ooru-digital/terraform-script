## Terraform AWS Network Skeleton

A terraform module which creates network skeleton on AWS with best practices in terms of network security, cost and optimization.

## Architecture

![Network_1 drawio](https://github.com/user-attachments/assets/5b5019a4-d2b2-4801-8add-451254f1db8d)


## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

---

## 🔐 AWS Permissions (Required)

Essential AWS IAM permissions required for complete MOSIP deployment:

### Core Infrastructure Services

- **VPC Management**: VPC, Subnets, Internet Gateways, NAT Gateways, Route Tables  
- **EC2 Services**: Instance management, Security Groups, Key Pairs, EBS Volumes  
- **Route 53**: DNS management, Hosted Zones, Record Sets  
- **IAM**: Role creation, Policy management, Instance Profiles  

### ✅ Recommended IAM Policy

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
````

> **Security Note:**
> For production environments, consider using more restrictive policies with specific resource ARNs and condition statements.

---

# 🚀 Terraform Infrastructure Deployment Guide

## 🧩 Overview

This guide provides step-by-step instructions to initialize, validate, plan, and apply Terraform configurations for deploying infrastructure on AWS.

---

## 🧰 Prerequisites

Before running the Terraform commands, make sure you have the following installed and configured on your system:

### 1️⃣ Terraform Installation

Download and install Terraform from the official website:
👉 [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

Verify the installation:

```bash
terraform -v
```

# AWS CLI Installation & Configuration

## 🧩 Step 1: Install the AWS CLI

Follow the official AWS documentation to install the AWS CLI on your system:
👉 [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

---

## ⚙️ Step 2: Configure the AWS CLI

Once installed, configure the AWS CLI with your AWS credentials by running the following command:

```bash
aws configure
```

You will be prompted to enter:

```
AWS Access Key ID
AWS Secret Access Key
Default region name (e.g., us-west-1)
```

# 🌍 Terraform Workflow

Before proceeding, ensure the following prerequisites are completed:

* **Terraform** is installed and configured on your system.
* **AWS CLI** is installed and configured with valid credentials.

---

## 📁 Directory Structure Overview

```
TERRAFORM-SCRIPT/
└── env/
    └── prod/
        └── compute/
            ├── core-vm/
            ├── main-vm/
            └── opt-vm/
└── network-skeleton/
    └── credissuer-network-skeleton/
```

Each folder contains its own Terraform configuration files:

* `backend.tf`
* `provider.tf`
* `main.tf`
* `output.tf`
* `variables.tf`
* `terraform.tfvars`

---

# 🧱 Deployment Steps per Module


## 🌐 1. Network Skeleton Deployment

Navigate to the **network skeleton** directory:

```bash
cd network-skeleton/credissuer-network-skeleton
```

Run Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

## 🖥️ 2. Core VM Deployment

Navigate to the **core-vm** directory:

```bash
cd env/prod/compute/core-vm
```

Run Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## 🖥️ 3. Opt VM Deployment

Navigate to the **opt-vm** directory:

```bash
cd env/prod/compute/opt-vm
```

Run Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## 🖥️ 4. Main VM Deployment

Navigate to the **main-vm** directory:

```bash
cd env/prod/compute/main-vm
```

Run Terraform commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

# 🧨 Destroy Infrastructure (Cleanup)

When you need to tear down the infrastructure, use the following command from within the same directory where you applied it:

```bash
terraform destroy -auto-approve
```


