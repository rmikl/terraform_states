# application loadbalancer scenario 

## ALB , 2x ec2 (server), 2x target groups

on 2 instances setup httpd with name of server printed in index.html, create ALB, and when call "/test" call one ec2 intance (target group 1) site, if call index.html second ec2 instance (second target group), if you call "/admin" it will return 404 return code.