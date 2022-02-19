sudo su ubuntu
cd /home/ubuntu/

echo ">>> installing Docker"

curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
echo added user to docker group

sudo echo ">>> installing Docker" > /home/ubuntu/docker.txt
