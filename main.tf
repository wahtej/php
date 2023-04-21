terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  shared_credentials_files = ["/home/ec2-user/.aws/credentials"]
}

locals {
  ssh_user         = "ec2-user"
  key_name         = "password"
  private_key_path = "/var/lib/jenkins/workspace/password.pem"
}

resource "aws_security_group" "httpd" {
  name   = "httpd_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "httpd" {
  ami                         = var.ami_id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.httpd.id]
  key_name                    = local.key_name
  tags = {
    Name = var.instance_name
  }
    

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.httpd.public_ip
    }
  }
  provisioner "local-exec" {
    command = "~/.local/bin/ansible-playbook  -i ${aws_instance.httpd.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
  }
}

output "httpd_ip" {
  value = aws_instance.httpd.public_ip
}
