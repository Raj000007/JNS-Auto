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

resource "aws_instance" "jenkins" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.medium"
  key_name               = "jenkiskey"
  vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
  provisioner "remote-exec" {
    inline = [
      "sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt install openjdk-17-jre -y",
      "sudo apt-get install jenkins -y",
      "sudo apt update",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\User\\Downloads\\jenkiskey.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}
