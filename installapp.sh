#!/bin/bash
echo "Starting installation" >> /tmp/log.txt
sudo apt-get update $$ sudo apt-get upgrade
sudo apt-get install -y git
mkdir /tmp/installation
