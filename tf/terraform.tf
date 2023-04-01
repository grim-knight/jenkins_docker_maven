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

  ingress{
	from_port = 30008
	to_port = 30008
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["70.120.100.125/32","52.54.254.122/32","44.195.129.92/32","24.242.173.10/32","54.161.114.126/32"]
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
  instance_type = "t2.medium"
  key_name = "sagartest"
  vpc_security_group_ids = [aws_security_group.flask_app_sg.id]

  # Define the user data script to install the necessary software and start the Flask application
  user_data = <<-EOF
              #!/bin/bash
                sudo yum update -y
              sudo yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo yum install -y python3-pip
              sudo pip3 install docker-compose
              sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
              sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
              sudo install minikube-linux-amd64 /usr/local/bin/minikube
              sudo curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubeadm
              sudo install -o root -g root -m 0755 kubeadm /usr/local/bin/kubeadm
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
