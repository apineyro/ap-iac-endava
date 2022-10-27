#!/bin/bash
echo "Starting installation"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y git nodejs npm docker docker-compose nginx
sudo mkdir /opt/app1
sudo chmod 777 /opt/app1
cd /opt/app1
git clone https://github.com/Nexpeque/cicdworkshop.git
cd cicdworkshop/
sudo npm install
sudo npm audit fix
sudo npm start
