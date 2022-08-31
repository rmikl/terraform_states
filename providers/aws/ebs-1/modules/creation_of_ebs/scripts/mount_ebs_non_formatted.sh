#!/bin/bash 

sudo mkfs.ext4  /dev/xvdh
sudo mkdir -p /media/ebs/
sudo mount /dev/xvdh /media/ebs/
sudo echo "hello from ebs" | sudo tee  /media/ebs/proof
sudo echo '/dev/xvdh /media/ebs/ ext4    defaults        0 0' | sudo tee /etc/fstab