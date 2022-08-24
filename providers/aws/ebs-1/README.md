# ebs-1 scenario that will cover createion of ebs volueme and copying it to different avaiability zone 

## there will be 2 modules:
* creation_of_ebs 
    * in this module there will be ec2 instance with ebs volume in the availability zone stored in varaible var.sorce_az
* copying_of_ebs_to_different_az 
    * in this module there will be ec2 instance in defferent AZ, we will creare snaphost of ebs from first module, and based on that new volume in defferent AZ will be created and pinned to another ec2 instance