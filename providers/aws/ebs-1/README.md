# ebs-1 scenario that will cover createion of ebs volueme and copying it to different avaiability zone 

## there will be 3 modules:
* creation_of_ebs 
    * in this module there will be ec2 instance with ebs volume in the availability zone stored in varaible var.sorce_az
* copying_of_ebs_to_different_az 
    * in this module there will be ec2 instance in defferent AZ (variable stored in var.dest_az), we will creare snaphost of ebs from first module (not encrypted) and based on that new volume in different AZ will be created (encrypted) and pinned to another ec2 instance
* creation_of_multi_attach_volume
    * in this module there will be multi attach volume created based on snapshot from previous module, based on that the volume will be created and attach to 3 ec2 instanced that also will be created in this module