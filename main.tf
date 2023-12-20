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
#
#
#module "mysql" {
#  source = "git::https://github.com/raghudevopsb75/tf-module-rds.git"
#
#  component      = "mysql"
#  env            = var.env
#  subnets        = module.vpc.db_subnets
#  vpc_cidr       = var.vpc_cidr
#  vpc_id         = module.vpc.vpc_id
#  instance_class = var.instance_class
#  kms_key_id     = var.kms_key_id
#}

#module "docdb" {
#  source = "git::https://github.com/raghudevopsb75/tf-module-docdb.git"
#
#  component            = "docdb"
#  env                  = var.env
#  subnets              = module.vpc.db_subnets
#  vpc_cidr             = var.vpc_cidr
#  vpc_id               = module.vpc.vpc_id
#  kms_key_id           = var.kms_key_id
#  docdb_instance_count = var.docdb_instance_count
#  docdb_instance_class = var.docdb_instance_class
#}
#
#module "elasticache" {
#  source = "git::https://github.com/raghudevopsb75/tf-module-elasticache.git"
#
#  component     = "elasticache"
#  env           = var.env
#  subnets       = module.vpc.db_subnets
#  vpc_cidr      = var.vpc_cidr
#  vpc_id        = module.vpc.vpc_id
#  kms_key_id    = var.kms_key_id
#  ec_node_type  = var.ec_node_type
#  ec_node_count = var.ec_node_count
#}

#module "rabbitmq" {
#  source = "git::https://github.com/raghudevopsb75/tf-module-rabbitmq.git"
#
#  component              = "rabbitmq"
#  env                    = var.env
#  subnets                = module.vpc.db_subnets
#  vpc_cidr               = var.vpc_cidr
#  vpc_id                 = module.vpc.vpc_id
#  kms_key_id             = var.kms_key_id
#  rabbitmq_instance_type = var.rabbitmq_instance_type
#  zone_id                = "Z09059901XRPHNYMGLMJ4"
#  bastion_node_cidr      = var.bastion_node_cidr
#}

#module "ms-components" {
#
#  depends_on = [module.docdb, module.mysql, module.elasticache, module.rabbitmq]
#
#  source = "git::https://github.com/raghudevopsb75/tf-module-app.git"
#
#  for_each               = var.components
#  component              = each.key
#  env                    = var.env
#  subnets                = module.vpc.app_subnets
#  vpc_cidr               = var.vpc_cidr
#  vpc_id                 = module.vpc.vpc_id
#  kms_key_id             = var.kms_key_id
#  instance_count         = each.value["count"]
#  prometheus_cidr        = var.prometheus_cidr
#  bastion_node_cidr      = var.bastion_node_cidr
#  instance_type          = each.value["instance_type"]
#  app_port               = each.value["app_port"]
#  alb_dns_name           = lookup(lookup(module.alb, each.value["lb_type"], null), "alb_dns_name", null)
#  zone_id                = "Z09059901XRPHNYMGLMJ4"
#  listener_arn           = lookup(lookup(module.alb, each.value["lb_type"], null), "listener_arn", null)
#  listener_rule_priority = each.value["listener_rule_priority"]
#}
#
#module "alb" {
#  source            = "git::https://github.com/raghudevopsb75/tf-module-alb.git"
#  for_each          = var.alb
#  alb_sg_allow_cidr = each.value["alb_sg_allow_cidr"]
#  alb_type          = each.key
#  env               = var.env
#  internal          = each.value["internal"]
#  subnets           = each.key == "private" ? module.vpc.app_subnets : module.vpc.public_subnets
#  vpc_id            = module.vpc.vpc_id
#  port              = each.value["port"]
#  protocol          = each.value["protocol"]
#  ssl_policy        = each.value["ssl_policy"]
#  certificate_arn   = each.value["certificate_arn"]
#}
#
#resource "aws_instance" "load-runner" {
#  ami                    = "ami-03265a0778a880afb"
#  instance_type          = "t3.medium"
#  vpc_security_group_ids = ["sg-07afa043b24022e4e"]
#  tags = {
#    Name = "load-runner"
#  }
#
#  provisioner "remote-exec" {
#    connection {
#      host     = self.private_ip
#      user     = "root"
#      password = "DevOps321"
#    }
#    inline = [
#      "curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install.sh | sudo bash",
#      "docker pull robotshop/rs-load:latest"
#    ]
#  }

#}

module "eks" {
  source = "git::https://github.com/raghudevopsb75/tf-module-eks.git"

  project_name   = var.project_name
  env            = var.env
  subnet_ids     = module.vpc.app_subnets
  instance_types = var.eks_instance_types
  node_count     = var.eks_node_count
}


