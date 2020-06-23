#!/bin/bash

apt-get update
apt-get install unzip

export a="0.12.23"
wget https://releases.hashicorp.com/terraform/${a}/terraform_${a}_linux_amd64.zip
unzip terraform_${a}_linux_amd64.zip
rm -rf terraform_${a}_linux_amd64.zip
mv terraform /usr/local/bin
cat >> ~/.bash_profile << EOF

export PATH=$PATH:/usr/local/bin/terraform

EOF

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
rm -rf awscliv2.zip
./aws/install

export b="1.5.4"
wget https://releases.hashicorp.com/packer/${b}/packer_${b}_linux_amd64.zip
unzip packer_${b}_linux_amd64.zip
rm -rf packer_${b}_linux_amd64.zip
mv packer /usr/local/bin

