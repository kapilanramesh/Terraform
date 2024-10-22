provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ansible_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu AMI (update with your region's AMI ID)
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
      # Step 1: Update the package index
      "sudo apt-get update",
      
      # Step 2: Install the software-properties-common package (needed for 'add-apt-repository')
      "sudo apt-get install -y software-properties-common",

      # Step 3: Add Ansible PPA (Personal Package Archive)
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",

      # Step 4: Install Ansible
      "sudo apt-get install -y ansible"
    ]
  }

  tags = {
    Name = "AnsibleServer"
  }
}

output "instance_ip" {
  value = aws_instance.ansible_server.public_ip
}
