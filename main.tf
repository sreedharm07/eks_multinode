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

  component     = "elasticache"
  env           = var.env
  subnets       = module.vpc.db_subnets
  vpc_cidr      = var.vpc_cidr
  vpc_id        = module.vpc.vpc_id
  kms_key_id    = var.kms_key_id
  ec_node_type  = var.ec_node_type
  ec_node_count = var.ec_node_count
}

module "rabbitmq" {
  source = "git::https://github.com/raghudevopsb75/tf-module-rabbitmq.git"

  component              = "rabbitmq"
  env                    = var.env
  subnets                = module.vpc.db_subnets
  vpc_cidr               = var.vpc_cidr
  vpc_id                 = module.vpc.vpc_id
  kms_key_id             = var.kms_key_id
  rabbitmq_instance_type = var.rabbitmq_instance_type
}

module "ms-components" {
  source = "git::https://github.com/raghudevopsb75/tf-module-app.git"

  for_each          = var.components
  component         = each.key
  env               = var.env
  subnets           = module.vpc.db_subnets
  vpc_cidr          = var.vpc_cidr
  vpc_id            = module.vpc.vpc_id
  kms_key_id        = var.kms_key_id
  instance_count    = each.value["count"]
  prometheus_cidr   = var.prometheus_cidr
  bastion_node_cidr = var.bastion_node_cidr
  instance_type     = each.value["instance_type"]
  app_port          = each.value["app_port"]
}

#module "alb" {
#  source            = "git::https://github.com/raghudevopsb75/tf-module-alb.git"
#  for_each          = var.alb
#  alb_sg_allow_cidr = var.vpc_cidr
#  alb_type          = each.key
#  env               = var.env
#  internal          = each.value["internal"]
#  subnets           = module.vpc.app_subnets
#  vpc_id            = module.vpc.vpc_id
#  dns_name          = "backend-${var.env}.rdevopsb73.online"
#  zone_id           = "Z09059901XRPHNYMGLMJ4"
#  tg_arn            = module.backend.tg_arn
#}

output "ms" {
  value = module.ms-components
}