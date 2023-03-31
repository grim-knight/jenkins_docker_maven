# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "flask_app_sg" {
  name_prefix = "flask_app_sg"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["70.120.100.125/32","52.54.254.122/32"]
 }

 egress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
}

# Create an EC2 instance for the Flask application
resource "aws_instance" "flask_app_instance" {
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.micro"
  key_name = "sagartest"
  vpc_security_group_ids = [aws_security_group.flask_app_sg.id]

  # Define the user data script to install the necessary software and start the Flask application
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
		sudo yum install python37
               curl -O https://bootstrap.pypa.io/get-pip.py
		python3 get-pip.py --user
              sudo pip3 install flask
		echo "from flask import Flask; app = Flask(__name__);" > /home/ec2-user/app.py
		echo "if __name__ == '__main__': app.run(host='0.0.0.0')" >> /home/ec2-user/app.py
              sudo nohup python3 /home/ubuntu/app.py > /dev/null 2>&1 &
              EOF

  # Associate an IAM instance profile with the instance (if necessary)
  # iam_instance_profile = aws_iam_instance_profile.flask_app_instance_profile.name

  tags = {
    Name = "sugar_app_instance"
  }
}

# Output the public IP address of the instance
output "public_ip_address" {
  value = aws_instance.flask_app_instance.public_ip
}
