terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ── VPC ──────────────────────────────────────────────────────────────────────
module "vpc" {
  source  = "/../modules/vpc"
  project = var.project
}

# ── ALB (created before compute so we can pass alb_sg_id to compute) ─────────
module "alb" {
  source            = "/../modules/alb"
  project           = var.project
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_instance_id   = module.compute.app_instance_id
}

# ── Compute ───────────────────────────────────────────────────────────────────
module "compute" {
  source             = "/../modules/compute"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnet_ids[0]
  private_subnet_id  = module.vpc.private_subnet_ids[0]
  alb_sg_id          = module.alb.alb_sg_id
  bastion_public_key = var.bastion_public_key
  app_public_key     = var.app_public_key
  # bastion SSH CIDR is auto-detected inside the compute module via data.http.my_ip
}

# ── Database ──────────────────────────────────────────────────────────────────
module "database" {
  source             = "/../modules/database"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.compute.app_sg_id
  db_password        = var.db_password
}

# ── Security (WAF + S3) ───────────────────────────────────────────────────────
module "security" {
  source      = "/../modules/security"
  project     = var.project
  bucket_name = var.bucket_name
  alb_arn     = module.alb.alb_arn
}
