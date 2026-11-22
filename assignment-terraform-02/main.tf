# Cấu hình Provder AWS và yêu cầu phiên bản
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

locals {
  ssh_key_name = "bdduong-do2606-keypair"
}

resource "aws_security_group" "quizz_sg" {
  name        = "bdduong_sg_tf"
  description = "Security Group for EC of Quizz Game"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bdduong_sg_tf"
  }
}

resource "aws_instance" "quizz_web" {
  ami           = "ami-01a395a37625fb28c"
  instance_type = "t2.micro"
  key_name      = local.ssh_key_name

  vpc_security_group_ids = [aws_security_group.quizz_sg.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "bdduong_instance_tf"
  }

}

output "public_ip" {
  description = "Public IPv4 address of Quiz Game EC2"
  value       = aws_instance.quizz_web.public_ip
}
