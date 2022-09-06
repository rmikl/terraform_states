#!/bin/bash

sudo yum install httpd -y 
sudo systemctl start httpd 
sudo echo "$HOSTNAME - target group2" | sudo tee /var/www/html/index.html
