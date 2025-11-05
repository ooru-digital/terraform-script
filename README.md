
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

## 🧑‍💻 Step 2: Creating an IAM User and Generating Access Keys in AWS

- Before connecting Terraform or the AWS CLI to your AWS account, you need proper credentials for authentication.  
There are **two common methods** to grant access — **IAM User** and **IAM Role**.  
In this setup, we will use the **IAM User** method.
---

## 🔹 Step 1: Create a New IAM User

1. Sign in to your **AWS Management Console**.  
2. Navigate to the **IAM (Identity and Access Management)** service.  
3. In the left-hand menu, click on **Users**.  
4. Click on the **Create user** button.  
5. Enter a **username** for the new user.  
6. Click **Next** to proceed to permissions.

---

## 🔹 Step 2: Attach Required Policies

1. Under the **Permissions options**, choose **Attach policies directly**.  
2. Search and select the following policies:
   - **AmazonVPCFullAccess**
   - **AmazonEC2FullAccess**
   - **AmazonS3FullAccess**
   - **IAMFullAccess**
3. Click **Next**, then **Create user** to finalize the process.

---

## 🔹 Step 3: Generate Access and Secret Keys

1. From the IAM dashboard, click on the **User** you just created.  
2. Go to the **Security credentials** tab.  
3. Scroll down to the **Access keys** section and click **Create access key**.  
4. Choose **Command Line Interface (CLI)** as the use case.  
5. Enter a short **description tag** (for example: `CLI Access`).  
6. Click **Create access key**.  
7. **Copy and securely store** both the **Access Key ID** and **Secret Access Key** — they will be used to configure the AWS CLI.

> ⚠️ **Important:** The Secret Access Key will only be shown once. Make sure to save it securely (e.g., in a password manager or encrypted file).

---



## ⚙️ Step 4: Configure the AWS CLI

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

## Step 4: Follow the steps below to create an Amazon S3 bucket using the AWS Management Console.

---

## 🔹 Step 1: Open the S3 Service

1. Sign in to your **AWS Management Console**.  
2. In the search bar at the top, type **S3**.  
3. Click on **S3** from the search results to open the **Amazon S3 Dashboard**.

---

## 🔹 Step 2: Create a New Bucket

1. Click on the **Create bucket** button.  
2. In the **Bucket name** field, enter a **unique name** for your bucket.  
   > 📝 Example: `terraform-state-bucket`  
3. Choose the **AWS Region** where you want the bucket to be created.  
4. Keep other settings as default (or adjust as per your requirements).  
5. Scroll down and click **Create bucket**.

---

## ✅ Step 3: Verify the Bucket Creation

Once created, you’ll be redirected to the **S3 bucket list** where your newly created bucket will appear.  
You can now use this bucket for:
- Storing Terraform state files  
  

---

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
cd env/prod/network-skeleton/credissuer-network-skeleton
```
## ⚙️ Customizing Terraform Variables Before Execution

Before running your Terraform code, you can modify the **`terraform.tfvars`** file to customize your infrastructure setup.  
This allows you to tailor the configuration according to your project’s requirements.

---

## 🔹 What You Can Modify

In the **`terraform.tfvars`** file, you can update the following variables (as per your network skeleton):

| Variable Name | Description | Example Value |
|----------------|--------------|----------------|
| `subnet_names` | List of subnet names to be created | `["public-subnet-1", "private-subnet-1"]` |
| `subnet_cidrs` | CIDR ranges for each subnet | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `program` | Name of your VPC or project | `"test-vpc"` |
| `subnet_azs` | Name of the availability zone | `"ap-south-1a"` |
| `public_route_table` | Name of the public route table | `"public-rt"` |
| `private_route_table` | Name of the private route table | `"private-rt"` |
| `env` | Name of the env | `"dev"` |
| `owner` | Name of the owner | `"ooru"` |
| `region` | Name of the region | `"ap-south-1"` |


### Before running your Terraform code, make sure to update the **`backend.tf`** file with the correct S3 bucket details.  
This ensures your Terraform state file is stored securely and consistently in Amazon S3.

---

## 🔹 Why Update the Backend?

Terraform uses a **backend** to store its state file (`terraform.tfstate`) — which tracks resource mappings between your configuration and actual cloud resources.  
By using an **S3 backend**, you can:
- Maintain a centralized and persistent state file  
- Enable collaboration between multiple team members  
- Protect against local data loss  

---

## 🔹 What You Need to Modify

In your **`backend.tf`** file, update the **S3 bucket name** (and optionally other backend parameters) to match the bucket you recently created in AWS.

| Parameter | Description | Example Value |
|------------|--------------|----------------|
| `bucket` | Name of the S3 bucket to store the Terraform state file | `"terraform-state-bucket"` |


---

## 🧩 Example `backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket = "credissuer-tf-state"   # here you need to change the bucket name
    key    = "env/prod/network/credissure/terraform.tfstate"
    region = "ap-south-1"
  }
}
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
# 💻 Configuring EC2 and Security Group Variables in Terraform

Before running your Terraform code, ensure that certain variables are correctly defined in the **`terraform.tfvars`** file.  
These variables are essential for creating your EC2 instance and its associated security group.

---

## 🔹 Variables to Configure

In the **`terraform.tfvars`** file, make sure to include or update the following:

| Variable Name | Description | Example Value |
|----------------|--------------|----------------|
| `key_name` | Name of your existing **EC2 Key Pair** used for SSH access. This key should already exist in AWS. You can also create it manually via the AWS Management Console. | `"ooru-mosip-key"` |
| `ec2_name` | The name assigned to your EC2 instance. | `"credissuer-core-vm"` |
| `sg_name` | The name of the Security Group that will be created or associated with the EC2 instance. | `"credissuer-core-vm-sg"` |

---
### 🔹Before running your Terraform configuration for the **core VM**, make sure to update the **S3 bucket name** in both the **`data.tf`** and **`backend.tf`** files.  

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
# 💻 Configuring EC2 and Security Group Variables in Terraform

Before running your Terraform code, ensure that certain variables are correctly defined in the **`terraform.tfvars`** file.  
These variables are essential for creating your EC2 instance and its associated security group.

---

## 🔹 Variables to Configure

In the **`terraform.tfvars`** file, make sure to include or update the following:

| Variable Name | Description | Example Value |
|----------------|--------------|----------------|
| `key_name` | Name of your existing **EC2 Key Pair** used for SSH access. This key should already exist in AWS. You can also create it manually via the AWS Management Console. | `"ooru-mosip-key"` |
| `ec2_name` | The name assigned to your EC2 instance. | `"credissuer-core-vm"` |
| `sg_name` | The name of the Security Group that will be created or associated with the EC2 instance. | `"credissuer-core-vm-sg"` |

### 🔹Before running your Terraform configuration for the **opt VM**, make sure to update the **S3 bucket name** in both the **`data.tf`** and **`backend.tf`** files.  


---
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
# 💻 Configuring EC2 and Security Group Variables in Terraform

Before running your Terraform code, ensure that certain variables are correctly defined in the **`terraform.tfvars`** file.  
These variables are essential for creating your EC2 instance and its associated security group.

---

## 🔹 Variables to Configure

In the **`terraform.tfvars`** file, make sure to include or update the following:

| Variable Name | Description | Example Value |
|----------------|--------------|----------------|
| `key_name` | Name of your existing **EC2 Key Pair** used for SSH access. This key should already exist in AWS. You can also create it manually via the AWS Management Console. | `"ooru-mosip-key"` |
| `ec2_name` | The name assigned to your EC2 instance. | `"credissuer-core-vm"` |
| `sg_name` | The name of the Security Group that will be created or associated with the EC2 instance. | `"credissuer-core-vm-sg"` |

### 🔹Before running your Terraform configuration for the **main VM**, make sure to update the **S3 bucket name** in both the **`data.tf`** and **`backend.tf`** files.  


---
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

