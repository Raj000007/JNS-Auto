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

resource "aws_instance" "sonarqube" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.medium"
  key_name               = "skillrary1234"
  vpc_security_group_ids = ["${aws_security_group.sonarqube_sg.id}"]
  user_data              = file("sonar.sh")
  tags = {
    "Name" = "SonarQube"
  }
}
