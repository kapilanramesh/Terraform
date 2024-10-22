provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "docker_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu AMI (update with your region's AMI ID)
  instance_type = "t2.micro"

  key_name = var.key_name

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl enable docker",
      "sudo systemctl start docker"
    ]
  }

  tags = {
    Name = "DockerServer"
  }
}

output "instance_ip" {
  value = aws_instance.docker_server.public_ip
}
