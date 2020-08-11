#
# Outputs
#

output "instance_ip_address" {
  value = aws_instance.ubuntu.private_ip
}

# NOTE: First step towards a model where we can re-use the EBS volume
output "ebs_volume_id" {
  value = aws_instance.ubuntu.ebs_block_device[*].volume_id
}

#
# Resources
#

resource "aws_iam_role" "ec2_role" {
  name = "ppacore-devbox-${var.dev_name}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ppacore-devbox-${var.dev_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ppacore-devbox-${var.dev_name}-ec2-policy"
  role = aws_iam_role.ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "ubuntu" {
  ami = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  key_name = aws_key_pair.ubuntu.key_name
  tags = {
    Name = "dev-for-${var.dev_name}"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.private_key_path)
    host = self.private_ip
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = var.ebs_volume_size
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y > /dev/null 2>&1",
      "sudo apt-get install awscli -y > /dev/null 2>&1",
      "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -",
      "sudo apt-get install nodejs -y > /dev/null 2>&1",
      "sudo apt-get install zip unzip -y > /dev/null 2>&1",
      "sudo npm install -g serverless > /dev/null 2>&1",
      "sudo chown -R $USER:$(id -gn $USER) /home/ubuntu/.config",
      "wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip",
      "unzip terraform_0.12.29_linux_amd64.zip",
      "sudo mv terraform /usr/local/bin/",
      "rm terraform_0.12.29_linux_amd64.zip",
      "sudo apt-get install docker.io -y > /dev/null 2>&1",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker $USER",
      "sudo wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb",
      "sudo dpkg -i packages-microsoft-prod.deb",
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y dotnet-sdk-3.1",
      "rm -f packages-microsoft-prod.deb"
    ]
  }
}

resource "aws_key_pair" "ubuntu" {
  key_name = "${var.dev_name}-kp"
  public_key = file(var.public_key_path)
}

provider "aws" {
  profile = "default"
  region = var.aws_region
}
