# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

#create a VPC
resource "aws_vpc" "vpc_jenkins"{
	cidr_block = "172.0.0.0/16"
	tags = {
		Name = "vpc_jenkins"
	}
}

#Create subnet
resource "aws_subnet" "subnet_jenkins"{
	cidr_block = "172.0.1.0/24"
	vpc_id = aws_vpc.vpc_jenkins.id	
	tags = {
		Name = "Subnet_jenkins"
	}
}


#Internet gateway
resource "aws_internet_gateway" "jenkins_igw"{
        vpc_id = aws_vpc.vpc_jenkins.id
        tags = {
                Name = "jenkins_igw"
        }
}

#Route table for the internet gateway
resource "aws_route_table" "rt"{
	vpc_id = aws_vpc.vpc_jenkins.id
	route{
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.jenkins_igw.id
	}
}


#Associate the subnets to the route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_jenkins.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_security_group" "flask_app_sg" {
  name_prefix = "flask_app_sg"
  vpc_id = aws_vpc.vpc_jenkins.id
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
    cidr_blocks = ["70.120.100.125/32", "72.181.11.222/32", "44.201.57.218/32", "10.1.29.165/32","52.54.254.122/32","24.242.173.10/32","54.161.114.126/32"]
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
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.flask_app_sg.id]
  subnet_id = aws_subnet.subnet_jenkins.id
  # Define the user data script to install the necessary software and start the Flask application
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
		mkdir -p /home/ec2-user/.ssh
		echo "${file("/home/ec2-user/jenkins/jenkins_docker_maven/tf/prod.pub")}" > /home/ec2-user/.ssh/authorized_keys
		chmod 700 /home/ec2-user/.ssh
		chmod 600 /home/ec2-user/authorized_keys
		echo "${file("/home/ec2-user/jenkins/jenkins_docker_maven/tf/prod")}" > /home/ec2-user/prod
		chmod 600 /home/ec2-user/prod
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
