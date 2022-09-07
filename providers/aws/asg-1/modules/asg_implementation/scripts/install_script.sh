#!/bin/bash

sudo yum install httpd -y 
sudo systemctl start httpd 
sudo echo "$HOSTNAME auto scaling group"  | sudo tee /var/www/html/index.html 