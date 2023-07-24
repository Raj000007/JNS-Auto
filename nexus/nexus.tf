terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  access_key = "AKIA4IMB4V72RSWVU77F"
  secret_key = "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"
  region     = "us-east-1"
}
resource "aws_instance" "Nexus" {
  ami                    = "ami-04823729c75214919"
  instance_type          = "t2.medium"
  key_name               = "jenkiskey"
  vpc_security_group_ids = ["${aws_security_group.Nexus-sgs.id}"]
  user_data                   = "${file("nexus.sh")}"
  tags = {
    "Name" = "Nexus"
  }

}