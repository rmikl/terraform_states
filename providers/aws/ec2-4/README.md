# ec2-4 sample sceanario taht will cover creation of 2 ec2 instances with usage of placement groups, elastic IP and ENI

instances: 
* high_availability_instance
* speed_instance

Scenario:
speed instance will have ENI with elastic IP, when speed instance wiil be shutdown, then ENI should be moved to high availability instance that is using high availability placement group. 

We will also use modules. 
