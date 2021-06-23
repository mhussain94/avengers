#!/bin/sh
sudo su 
apt update
apt install -y nginx
echo "<h1>Assemble Avengers</h1>" | tee /var/www/html/index.html
systemctl restart nginx.service
