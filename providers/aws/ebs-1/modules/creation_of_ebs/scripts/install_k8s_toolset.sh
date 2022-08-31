#!/bin/bash 

mkdir -p /media/ebs/
mount /dev/sdh /media/ebs 

echo "hello from ebs" > /media/ebs/proof