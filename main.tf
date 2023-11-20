module "vpc" {
  source                 = "git::https://github.com/raghudevopsb75/tf-module-vpc.git"
  vpc_cidr               = var.vpc_cidr
  env                    = var.env
  public_subnets         = var.public_subnets
  web_subnets            = var.web_subnets
  app_subnets            = var.app_subnets
  db_subnets             = var.db_subnets
  azs                    = var.azs
  account_no             = var.account_no
  default_vpc_id         = var.default_vpc_id
  default_vpc_cidr       = var.default_vpc_cidr
  default_route_table_id = var.default_route_table_id
}


module "mysql" {
  source = "git::https://github.com/raghudevopsb75/tf-module-rds.git"

  component      = "mysql"
  env            = var.env
  subnets        = module.vpc.db_subnets
  vpc_cidr       = var.vpc_cidr
  vpc_id         = module.vpc.vpc_id
  instance_class = var.instance_class
  kms_key_id     = var.kms_key_id
}

module "docdb" {
  source = "git::https://github.com/raghudevopsb75/tf-module-docdb.git"

  component            = "docdb"
  env                  = var.env
  subnets              = module.vpc.db_subnets
  vpc_cidr             = var.vpc_cidr
  vpc_id               = module.vpc.vpc_id
  kms_key_id           = var.kms_key_id
  docdb_instance_count = var.docdb_instance_count
  docdb_instance_class = var.docdb_instance_class
}

module "elasticache" {
  source = "git::https://github.com/raghudevopsb75/tf-module-elasticache.git"

  component            = "elasticache"
  env                  = var.env
  subnets              = module.vpc.db_subnets
  vpc_cidr             = var.vpc_cidr
  vpc_id               = module.vpc.vpc_id
  kms_key_id           = var.kms_key_id
  ec_node_type         = var.ec_node_type
  ec_node_count        = var.ec_node_count
}

