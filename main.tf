provider "aws" {
  profile = "default"
  region = var.aws_region
}

resource "aws_instance" "ubuntu" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  key_name = aws_key_pair.ubuntu.key_name
  tags = {
    Name = "dev-for-${var.dev_name}"
  }

  connection {
    type = "ssh"
    user = var.dev_name
    private_key = file(var.private_key_path)
    host = self.public_ip
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 8
  }
}

resource "aws_key_pair" "ubuntu" {
  key_name = "${var.dev_name}-kp"
  public_key = file(var.public_key_path)
}