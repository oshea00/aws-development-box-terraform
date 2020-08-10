variable "aws_region" {
    default = "us-east-1"
}

variable "instance_type" {
    default = "t3a.large"
}

variable "ami" {
    # Ubuntu 18.04 LTS
    default = "ami-05801d0a3c8e4c443"
}

variable "vpc_security_group_ids" {
    default = ["sg-06c448098d6d69561", "sg-07673f7076674d14b" ]
}

variable "subnet_id" {
    default = "subnet-05b2d37a540c03402"
}

variable "dev_name" {
    type = string
    description = "Name of developer (nospaces) deploying this instance"
}

variable "public_key_path" {
    default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
    default = "~/.ssh/id_rsa"
}