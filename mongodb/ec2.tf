resource "aws_spot_instance_request" "spot-instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.MONGODB_INSTANCE_TYPE
  wait_for_fulfillment   = true
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_ID, count.index)
  vpc_security_group_ids = [aws_security_group.allow-mongodb.id]
  //  root_block_device {
  //    volume_size = 10
  //  }
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.spot-instance.spot_instance_id
  key         = "Name"
  value       = "mongodb-${var.ENV}"
}