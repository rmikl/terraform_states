# route53-1 scenario

## 1 ALB with one target group with one ec2 instance and tree records in hosted zone for rmikl.info 
## another 7 ec2 instances
## extra 1 instances in SouthEast Asia 

### record types: CNAME, A, APAX
### CNAME record: demo1.rmikl.info -> points to ALB
### A record: demo2.rmikl.info -> points to ALB
### APAX record: rmikl.info -> points to ALB
### A record with simple routing: demo3.rmikl.info ->points to 2 ip addresses of ec2 instances
### A record with weighted routing rules: demo4.rmikl.info -> points 80% to one instance and 20% to another instance
### A record with latency routing rule: demo5.rmikl.info -> point to both ec2 in europe and asia
### A record with failover: demo6.rmikl.info -> define 2 enpoints and hhealth check for one, then hibernate and see if the DNS record will start to point to failover
### A record with geolocation: demo7 if youre in the EUROPE go to ec2 instance in eu-central if not go to ec2 instance in SouthEast Asia 
### A record with multivalue with heath checks to 3 ec2 instances  

NOTE: USE "dig" command to inspect various scenarios 