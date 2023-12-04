env               = "prod"
project_name      = "roboshop"
kms_key_id        = "arn:aws:kms:us-east-1:739561048503:key/e8e78cec-c8e2-4f7d-a525-554ed53015d2"
bastion_node_cidr = ["172.31.23.123/32"]
prometheus_cidr   = ["172.31.17.71/32"]

## VPC
vpc_cidr               = "10.20.0.0/16"
public_subnets         = ["10.20.0.0/24", "10.20.1.0/24"]
web_subnets            = ["10.20.2.0/24", "10.20.3.0/24"]
app_subnets            = ["10.20.4.0/24", "10.20.5.0/24"]
db_subnets             = ["10.20.6.0/24", "10.20.7.0/24"]
azs                    = ["us-east-1a", "us-east-1b"]
default_vpc_id         = "vpc-0468c874d427a36de"
default_vpc_cidr       = "172.31.0.0/16"
default_route_table_id = "rtb-005398010e7bea680"
account_no             = "739561048503"


## RDS
instance_class = "db.t3.medium"


# Docdb
docdb_instance_count = 1
docdb_instance_class = "db.t3.medium"

## Elasticache
ec_node_type  = "cache.t3.micro"
ec_node_count = 1

# Rabbitmq
rabbitmq_instance_type = "t3.micro"

components = {
  frontend = {
    count                  = 2
    instance_type          = "t3.micro"
    app_port               = 80
    lb_type                = "public"
    listener_rule_priority = 100
  }
  catalogue = {
    count                  = 2
    instance_type          = "t3.micro"
    app_port               = 8080
    lb_type                = "private"
    listener_rule_priority = 100
  }
  cart = {
    count                  = 2
    instance_type          = "t3.micro"
    app_port               = 8080
    lb_type                = "private"
    listener_rule_priority = 101
  }
  user = {
    count                  = 2
    instance_type          = "t3.micro"
    app_port               = 8080
    lb_type                = "private"
    listener_rule_priority = 102
  }
  shipping = {
    count                  = 3
    instance_type          = "t3.large"
    app_port               = 8080
    lb_type                = "private"
    listener_rule_priority = 103
  }
  payment = {
    count                  = 2
    instance_type          = "t3.micro"
    app_port               = 8080
    lb_type                = "private"
    listener_rule_priority = 104
  }
#  dispatch = {
#    count                  = 2
#    instance_type          = "t3.micro"
#    app_port               = 8080
#    lb_type                = "private"
#    listener_rule_priority = 105
#  }
}


alb = {
  public = {
    internal          = false
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = "arn:aws:acm:us-east-1:739561048503:certificate/6414e7b8-1da5-4a92-a3a8-d66334ae5696"
    alb_sg_allow_cidr = "0.0.0.0/0"
  }
  private = {
    internal          = true
    port              = 80
    protocol          = "HTTP"
    ssl_policy        = null
    certificate_arn   = null
    alb_sg_allow_cidr = "10.20.0.0/16"
  }
}

eks_instance_types = ["t3.large"]
eks_node_count = 3
