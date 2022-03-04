resource "aws_elasticache_cluster" "redis-cluster" {
  cluster_id             = "redis-${var.ENV}"
  engine                 = "redis"
  node_type              = "cache.t3.micro"
  num_cache_nodes        = 1
  parameter_group_name   = "default.redis6.x"
  engine_version         = "6.x"
  port                   = 6379
  subnet_group_name      = aws_db_subnet_group.redis.name
  security_group_ids = [aws_security_group.allow-redis.id]
}

resource "aws_db_subnet_group" "redis" {
  name       = "redis"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_ID
}
