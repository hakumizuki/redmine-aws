#!/bin/bash

# Update package
sudo yum update -y
# Install and Start Docker
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service  # Auto activation
sudo systemctl start docker.service

# Run redmine
docker run -d -p 3000:3000 --name redmine-aws redmine:4.2.1

# Add amazon-linux2 defualt user to docker group
sudo usermod -aG docker ec2-user
