#!/bin/bash

# Make sure that port 8080 is added to the firewall or in the aws security group

apt-get update

apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Installing java for jenkins

apt-get install -y openjdk-8-jdk

# Installing jenkins on the aws ec2 server

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install -y jenkins

