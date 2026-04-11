# ═══════════════════════════════════════════════════════════
#  SecureCart – Root Module
#  Orchestrates: networking → security → compute → alb → rds → s3 → waf
# ═══════════════════════════════════════════════════════════

# ─────────────────────────────────────────────
# 1. Networking Module
# Creates VPC, subnets, IGW, NAT GW, route tables
# ─────────────────────────────────────────────
module "networking" {
  source = "./modules/networking"

  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az1                   = var.az1
  az2                   = var.az2
}

# ─────────────────────────────────────────────
# 2. Security Module
# Creates security groups for ALB, App, Bastion, RDS
# ─────────────────────────────────────────────
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  vpc_cidr     = var.vpc_cidr

  depends_on = [module.networking]
}

# ─────────────────────────────────────────────
# 3. Compute Module
# Creates SSH key pairs, bastion host, app EC2 instance
# ─────────────────────────────────────────────
module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  bastion_ami           = var.bastion_ami
  app_ami               = var.app_ami
  bastion_instance_type = var.bastion_instance_type
  app_instance_type     = var.app_instance_type
  public_subnet_1_id    = module.networking.public_subnet_1_id
  private_subnet_1_id   = module.networking.private_subnet_1_id
  bastion_sg_id         = module.security.bastion_sg_id
  app_sg_id             = module.security.app_sg_id

  depends_on = [module.networking, module.security]
}

# ─────────────────────────────────────────────
# 4. ALB Module
# Creates Application Load Balancer, target group, listener
# ─────────────────────────────────────────────
module "alb" {
  source = "./modules/alb"

  project_name       = var.project_name
  environment        = var.environment
  alb_sg_id          = module.security.alb_sg_id
  public_subnet_1_id = module.networking.public_subnet_1_id
  public_subnet_2_id = module.networking.public_subnet_2_id
  vpc_id             = module.networking.vpc_id
  app_instance_id    = module.compute.app_instance_id

  depends_on = [module.compute, module.security]
}

# ─────────────────────────────────────────────
# 5. Secrets Module
# Generates a random password and stores credentials
# in AWS Secrets Manager — no plaintext passwords anywhere
# ─────────────────────────────────────────────
module "secrets" {
  source = "./modules/secrets"

  project_name            = var.project_name
  environment             = var.environment
  db_username             = var.db_username
  db_name                 = var.db_name
  recovery_window_in_days = var.secret_recovery_window
}

# ─────────────────────────────────────────────
# 6. RDS Module
# Creates MySQL RDS instance and DB subnet group
# ─────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  project_name           = var.project_name
  environment            = var.environment
  private_subnet_1_id    = module.networking.private_subnet_1_id
  private_subnet_2_id    = module.networking.private_subnet_2_id
  rds_sg_id              = module.security.rds_sg_id
  secret_arn             = module.secrets.secret_arn
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_engine_version      = var.db_engine_version
  db_multi_az            = var.db_multi_az
  db_skip_final_snapshot     = var.db_skip_final_snapshot
  db_backup_retention_period = var.db_backup_retention_period

  depends_on = [module.networking, module.security, module.secrets]
}

# ─────────────────────────────────────────────
# 7. S3 Module
# Creates S3 bucket with encryption, versioning, public access block
# ─────────────────────────────────────────────
module "s3" {
  source = "./modules/s3"

  project_name    = var.project_name
  environment     = var.environment
  s3_bucket_name  = var.s3_bucket_name
}

# ─────────────────────────────────────────────
# 8. WAF Module
# Creates WAF Web ACL and associates it with the ALB
# ─────────────────────────────────────────────
module "waf" {
  source = "./modules/waf"

  project_name                = var.project_name
  environment                 = var.environment
  alb_arn                     = module.alb.alb_arn
  waf_enable_common_rules     = var.waf_enable_common_rules
  waf_enable_bad_inputs_rules = var.waf_enable_bad_inputs_rules
  waf_enable_sqli_rules       = var.waf_enable_sqli_rules

  depends_on = [module.alb]
}
