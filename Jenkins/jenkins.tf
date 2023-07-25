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

resource "aws_instance" "jenkins" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.medium"
  key_name               = "skillrary1234"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  provisioner "remote-exec" {
    inline = [
      "sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt install openjdk-17-jre -y",
      "sudo apt-get install jenkins -y",
      "sudo apt update",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
      "sudo apt update -y",
      "sudo apt install openjdk-8-jdk -y",
      "sudo -i",
      "ls /usr/lib/jvm",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\User\\Downloads\\skillrary1234.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}
