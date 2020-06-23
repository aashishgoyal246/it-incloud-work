#!/bin/bash

# Updating the repo's

apt-get update

# Installing the required packages

apt-get install rng-tools unzip -y

# Installing awscli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Performing the aws operations

sleep 2
aws s3 cp s3://awsitops-bucket/ip.txt .

sleep 2
aws s3 cp s3://awsitops-bucket/key.txt .

# Fetching the key and ip

a="cat key.txt"
b=$(eval "$a")

c="cat ip.txt"
d=$(eval "$c")

# Installing and updating packages from new repository

sleep 3
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $b

sleep 3
add-apt-repository "deb http://$d/ xenial main"

sleep 3
apt-get update

sleep 3
apt-get install percona-release -y --allow-unauthenticated


