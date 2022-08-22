# ec2-4 sample sceanario taht will cover creation of 2 ec2 instances with usage of placement groups, elastic IP and ENI

instances: 
* redundant_instance
* speed_instance

Scenario:
speed_instance will have ENI with elastic IP, when speed instance would be hibernated, then ENI could be manually moved (NOT THE BEST PRACTICE) to redundant_instance that is using high availability placement group, speed instance will be hibernated, so it needs to have configured proper ebs. 

We will also use modules. 

DISCLAIMER: 
moving manually part of infrastructure created by terraform should not take place in prod environment, this WILL cause differences between .tfstate and state of infra in the cloud. 
You need to know what Youre doing before You decide to change it in that way.