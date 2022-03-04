resource "aws_spot_instance_request" "spot-instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.RABBITMQ_INSTANCE_TYPE
  wait_for_fulfillment   = true
  subnet_id     = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_ID[0]
  vpc_security_group_ids = [aws_security_group.allow-rabbitmq.id]
  //  root_block_device {
  //    volume_size = 10
  //  }
}

resource "aws_ec2_tag" "tag" {
  resource_id = aws_spot_instance_request.spot-instance.spot_instance_id
  key         = "Name"
  value       = "rabbitmq-${var.ENV}"
}

resource "null_resource" "ansible-apply" {


  provisioner "remote-exec" {
    connection {
      host      = aws_spot_instance_request.spot-instance.private_ip
      user      = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["SSH_USER"]
      password  = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["SSH_PASS"]
    }
    inline = [
      "ansible-pull -U https://github.com/teja-cloudnative/ansible roboshop-pull.yml -e COMPONENT=rabbitmq -e ENV=${var.ENV}"
    ]
  }
}