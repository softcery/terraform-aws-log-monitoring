module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.9.0"

  identifier = var.name

  # engine settings
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  family         = var.rds_family

  # instance settings
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  storage_type          = var.rds_storage_type
  max_allocated_storage = var.rds_max_allocated_storage
  iops                  = var.rds_iops

  # credentials
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  create_random_password = false

  # security settings
  iam_database_authentication_enabled = false
  vpc_security_group_ids              = [aws_security_group.db.id]
  publicly_accessible                 = var.rds_publicly_accessible

  # maintenance settings
  maintenance_window = var.rds_maintenance_window

  # backup settings
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window

  # monitoring settings
  # TODO: disabled for now, parameterize this
  monitoring_interval = 0

  # located in public subnet for outside access
  # TODO: change to private subnets in production
  create_db_subnet_group = true
  subnet_ids             = module.vpc.public_subnets

  # Database Deletion Protection
  deletion_protection = var.rds_deletion_protection_enabled

  tags = local.tags
}

// db sg that allows connecting to 5432 port
resource "aws_security_group" "db" {
  name   = "db-${var.name}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

// route53 record
resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.base.id
  name    = "db.${aws_route53_zone.base.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.db.db_instance_address]
}
