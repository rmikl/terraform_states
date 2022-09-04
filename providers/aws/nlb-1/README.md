# network loadbalancer scenario 

## NLB , 2x ec2 (server), 2x target groups

on 2 instances setup httpd with name of server printed, create NLB, and when call port 80 call one ec2 intance (target group 1) site, if call port 81 second ec2 instance (second target group)