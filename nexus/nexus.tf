terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  access_key = "AKIAU4ZRQUPGXUDNUPUQ"
  secret_key = "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"
  region     = "us-east-1"
}
resource "aws_instance" "Nexus" {
  ami                    = "ami-0f9ce67dcf718d332"
  instance_type          = "t2.medium"
  key_name               = "skillrary1234"
  vpc_security_group_ids = ["${aws_security_group.Nexus_sg.id}"]
  user_data                   = "${file("nexus.sh")}"
  tags = {
    "Name" = "Nexus"
  }

}
