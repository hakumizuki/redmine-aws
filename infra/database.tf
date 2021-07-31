resource "aws_db_subnet_group" "main" {
  name = "${local.prefix}-main"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-main"
    },
  )
}

resource "aws_security_group" "rds" {
  description = "Allow access to the RDS database instance."
  name        = "${local.prefix}-rds-inbound-access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432

    # Limit by security groups
    security_groups = [
      aws_security_group.redmine.id,
    ]
  }

  tags = local.common_tags
}

resource "aws_db_instance" "main" {
  identifier              = "${local.prefix}-db"
  name                    = "postgres"
  allocated_storage       = 20
  max_allocated_storage   = 50
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "9.6"
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  password                = var.db_password
  username                = var.db_username
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true # 削除作成をスムーズに行うために必要
  vpc_security_group_ids  = [aws_security_group.rds.id]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-main"
    },
  )
}
