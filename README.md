## Terraform AWS Network Skeleton

A terraform module which creates network skeleton on AWS with best practices in terms of network security, cost and optimization.

## Architecture

![Network_1 drawio](https://github.com/user-attachments/assets/5b5019a4-d2b2-4801-8add-451254f1db8d)


## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|


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

- **Terraform** is installed and configured on your system.  
- **AWS CLI** is installed and configured with valid credentials.

Once prerequisites are complete, follow the steps below:

---

##  Step 1: Initialize Terraform

```bash
terraform init
```
- Description:
Initializes the Terraform working directory.
This command downloads the required provider plugins and sets up the local backend.

##  Step 2: Validate Terraform Configuration
```bash
terraform validate
```
- Description:
Validates the Terraform configuration files to ensure that the syntax is correct and all required arguments are provided.

##  Step 3: Create a Terraform Execution Plan

```bash
terraform plan
```
- Description:
Generates and displays an execution plan, showing what Terraform will do before actually making any changes.


## Step 4: Apply the Terraform Plan
```bash
terraform apply -auto-approve
```
- Description:
Applies the Terraform configuration to provision infrastructure automatically, without prompting for manual approval.

## Step 5: Destroy the Infrastructure
```bash
terraform destroy -auto-approve
```
- terraform destroy -auto-approve



