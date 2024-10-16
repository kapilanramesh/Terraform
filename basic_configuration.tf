# Define the provider (e.g., AWS)
provider "aws" {
  region = "us-east-1"
}

# Define an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }
}
