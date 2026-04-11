# SecureCart – Terraform Module

A production-aligned, fully modularised Terraform configuration for the **SecureCart** AWS infrastructure. Each layer of the stack is its own child module with clearly defined inputs, outputs, and responsibilities.

---

## Architecture Overview

```
Internet
   │
   ▼
[WAF Web ACL]  ◄──── blocks SQLi, XSS, bad inputs
   │
   ▼
[ALB]  (public subnets – AZ-1, AZ-2)
   │
   ▼
[App EC2]  (private subnet – AZ-1)
   │         │
   │         ▼
   │       [RDS MySQL]  (private subnets – AZ-1, AZ-2)
   │
[Bastion Host]  (public subnet – AZ-1, SSH jump box)
   │
[S3 Bucket]  (encrypted, versioned, no public access)
```

**Network flow for private instances:**  
Private EC2 → Private Route Table → NAT Gateway (public-1) → IGW → Internet

---

## Module Structure

```
securecart/
├── main.tf              # Root module – wires child modules together
├── variables.tf         # All input variable definitions
├── outputs.tf           # All root-level outputs
├── versions.tf          # Provider version constraints
├── provider.tf          # AWS provider + default_tags
├── terraform.tfvars     # Environment-specific values (dev example)
│
└── modules/
    ├── networking/      # VPC, subnets, IGW, NAT GW, route tables
    ├── security/        # Security groups (ALB, app, bastion, RDS)
    ├── compute/         # Key pairs, bastion EC2, app EC2
    ├── alb/             # ALB, target group, HTTP listener
    ├── rds/             # DB subnet group, MySQL RDS
    ├── s3/              # S3 bucket, encryption, versioning, lifecycle
    └── waf/             # WAFv2 Web ACL + ALB association
```

---

## Quick Start

### 1. Prerequisites
- Terraform ≥ 1.6.0
- AWS CLI configured (`aws configure`) with sufficient IAM permissions
- An existing AMI ID valid in your target region

### 2. Clone / copy the module

```bash
git clone <your-repo-url>
cd securecart
```

### 3. Set the DB password securely (never commit to git)

```bash
export TF_VAR_db_password="YourStrongPassword123!"
```

Or use a `.tfvars` file that is in `.gitignore`:

```hcl
# secrets.tfvars  ← add to .gitignore
db_password = "YourStrongPassword123!"
```

### 4. Initialise and deploy

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 5. Retrieve key outputs

```bash
terraform output alb_dns_name       # Browse to your app
terraform output bastion_public_ip  # SSH jump-box IP
terraform output rds_endpoint       # DB connection string
```

---

## SSH Access Pattern

```
Local machine  →  SSH to bastion (public IP, port 22)
                     │
                     └──→  SSH to app (private IP, port 22)
```

Both PEM files are written to the project root after `terraform apply`:

| File | Key for |
|------|---------|
| `securecart-bastion-dev.pem` | Bastion host |
| `securecart-app-dev.pem` | Application server |

```bash
# Step 1 – connect to bastion
ssh -i securecart-bastion-dev.pem ec2-user@<bastion_public_ip>

# Step 2 – from bastion, jump to app
ssh -i securecart-app-dev.pem ec2-user@<app_private_ip>
```

---

## Module Inputs Reference

| Variable | Default | Description |
|----------|---------|-------------|
| `project_name` | `securecart` | Prefix for all resource names |
| `environment` | `dev` | Environment label |
| `region` | `us-east-1` | AWS deployment region |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `az1` / `az2` | `us-east-1a/b` | Availability zones |
| `bastion_ami` | *(set in tfvars)* | AMI for bastion EC2 |
| `app_ami` | *(set in tfvars)* | AMI for app EC2 |
| `db_password` | **required** | RDS master password (sensitive) |
| `db_multi_az` | `false` | Enable RDS Multi-AZ |
| `s3_bucket_name` | *(set in tfvars)* | Globally unique bucket name |
| `waf_enable_*` | `true` | Toggle WAF managed rule groups |

Full variable descriptions are in `variables.tf`.

---

## Security Considerations

| Area | Current | Recommended for Production |
|------|---------|---------------------------|
| DB password | `terraform.tfvars` | AWS Secrets Manager |
| HTTP only | Port 80 listener | Add HTTPS + ACM cert, redirect 80→443 |
| RDS deletion protection | `false` | `true` |
| RDS Multi-AZ | `false` | `true` |
| IMDSv2 | Enforced on EC2 | ✅ Already done |
| Encryption at rest | AES-256 (S3 + RDS) | ✅ Already done |
| WAF | 3 managed rule groups | Add rate-based rules |

---

## Destroy

```bash
terraform destroy
```

> **Note:** PEM files created locally are not removed by `terraform destroy`. Delete them manually after teardown.
