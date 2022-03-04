resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = "mydb"
  username               = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_USER"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_PASS"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.allow-mysql.id]
  tags                   =
  {
    Name = "mysql-${var.ENV}"
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_ID

  tags = {
    Name = "MySQL subnet group"
  }
}

