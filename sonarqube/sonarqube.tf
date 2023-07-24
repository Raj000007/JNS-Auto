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

resource "aws_instance" "sonarqube" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.medium"
  key_name               = "jenkiskey"
  vpc_security_group_ids = ["${aws_security_group.sonarqube.id}"]
  user_data              = file("sonar.sh")
  tags = {
    "Name" = "Jenkins"
  }
}