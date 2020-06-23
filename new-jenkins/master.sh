#!/bin/bash

apt-get update

apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

swapoff -a
lsmod | grep br_netfilter
touch /etc/sysctl.d/k8.conf
cat > /etc/sysctl.d/k8.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
apt-get install -y iptables arptables ebtables
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
touch /etc/apt/sources.list.d/kubernetes.list
cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get -y install docker.io
systemctl start docker
apt-get install -y kubelet kubeadm kubectl
systemctl start kubelet

apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y containerd.io=1.2.10-3 docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.4~3-0~ubuntu-$(lsb_release -cs)

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet

ifconfig eth0 | grep "inet " | awk -F'[: ]+' '{ print $4 }' > ip.txt

#docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

sleep 5

kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl config set-context --current --namespace=kube-system

kubeadm token create --print-join-command > join.txt
aws s3 cp join.txt s3://awsitops-bucket
aws s3 cp ip.txt s3://awsitops-bucket
