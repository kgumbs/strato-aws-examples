provider "aws" {
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"

  endpoints {
   efs = "https://${var.northbound_ip}/api/v2/aws/efs"
   ec2 = "https://${var.northbound_ip}/api/v2/aws/ec2"
  }

  insecure = "true"
  skip_metadata_api_check = true
  skip_credentials_validation = true
  skip_requesting_account_id = true
  region = "eu-west-1"
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg_1"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "fs" {
    creation_token = "efs-example"
    encrypted = "false"
    performance_mode = "generalPurpose"
    throughput_mode = "bursting"
}

resource "aws_efs_mount_target" "efs-mt-example" {
   file_system_id  = "${aws_efs_file_system.fs.id}"
   subnet_id = "${var.subnet_id}"
   security_groups = ["${aws_security_group.efs_sg.id}"]
}

