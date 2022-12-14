#/bin/sh
echo "EJ-Upadate System"
sudo yum -y update
echo "EJ-Install Docker"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker vagrant