# classic loadbalancer scenario 

## ALB --> ASG

create ASG temaplate pin it to ALB, 
change scaling so that it will create two instances,
configure user data to have httpd and put hostname into index.html 
add sticky session
check health
add scaling policy for cpu, then put load on one instance
add scaling policybased on schedule and chekc theamount of nodes