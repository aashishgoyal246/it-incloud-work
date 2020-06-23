#!/bin/bash

# Updating the repo's

apt-get update

# Installing the required tools

apt-get install rng-tools nginx reprepro unzip -y

# Installing awscli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Fetching the IP

curl icanhazip.com > ip.txt
cat > index.html <<EOF

Welcome to It-InCloud

EOF

aws s3 cp index.html s3://awsitops-bucket

# Performing gpg key operations

touch myscript private.key public.key signing.key
email=$1
cat > myscript <<EOF
         %echo Generating a public and sub key
         Key-Type: RSA
         Key-Length: 4096
         Subkey-Type: RSA
         Subkey-Length: 4096
         Name-Real: Test
         Name-Comment: This is for test
         Name-Email: $email
         Expire-Date: 0
         # Do a commit here, so that we can later print "done" :-)
         %commit
         %echo done
EOF
gpg --batch --gen-key myscript
gpg --list-secret-keys
keyid=$(gpg --list-secret-keys | grep -B1 $email | grep sec | cut -d "/" -f2 | cut -d " " -f1)
echo $keyid
subid=$(gpg --list-secret-keys | grep -A1 $email | grep ssb | cut -d "/" -f2 | cut -d " " -f1)
echo $subid
gpg --export-secret-key $keyid > private.key
gpg --export $keyid >> private.key
gpg --export $keyid > public.key
gpg --export-secret-subkeys $subid > signing.key
gpg --import public.key signing.key
gpg --list-secret-keys
gpg --keyserver keyserver.ubuntu.com --send-key $keyid
sleep 5
gpg --keyserver keyserver.ubuntu.com --recv-keys $keyid
gpg --export --armor $keyid | apt-key add -

# Copying key-id to text file

echo $keyid > key.txt

# Setting up a new repo

mkdir -p /var/repositories/
cd /var/repositories/
mkdir conf
cd conf/
touch distributions
cat > distributions << EOF
Codename:xenial
Components: main
Architectures: i386 amd64
SignWith: $keyid
EOF
mkdir -p /tmp/debs
cd /tmp/debs
wget https://repo.percona.com/apt/percona-release_0.1-6.xenial_all.deb
wget https://downloads.mariadb.com/MariaDB/mariadb-10.2/repo/ubuntu/mariadb-10.2.31-ubuntu-xenial-amd64-debs.tar
tar -xvf mariadb-10.2.31-ubuntu-xenial-amd64-debs.tar
rm -rf mariadb-10.2.31-ubuntu-xenial-amd64-debs.tar
cd mariadb-10.2.31-ubuntu-xenial-amd64-debs/
cd ..
cp percona-release_0.1-6.xenial_all.deb mariadb-10.2.31-ubuntu-xenial-amd64-debs/
cd mariadb-10.2.31-ubuntu-xenial-amd64-debs/

# Copying packages to S3

aws s3 cp /tmp/debs/mariadb-10.2.31-ubuntu-xenial-amd64-debs/ s3://awsitops-bucket/packages --recursive

# Installing nginx

reprepro -b /var/repositories includedeb xenial *.deb
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
touch /etc/nginx/sites-available/default
cat > /etc/nginx/sites-available/default << EOF
server {
    ## Let your repository be the root directory
    root        /var/repositories;
    ## Always good to log
    access_log  /var/log/nginx/repo.access.log;
    error_log   /var/log/nginx/repo.error.log;
    ## Prevent access to Reprepro's files
    location ~ /(db|conf)/ {
        deny        all;
        return      404;
    }
    autoindex on;
}
EOF
service nginx reload
service nginx restart

# Copying the ip and hash key to S3 bucket

cd
aws s3 cp ip.txt s3://awsitops-bucket
aws s3 cp key.txt s3://awsitops-bucket
