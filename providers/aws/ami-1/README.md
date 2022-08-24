# ami-1 scenario that will cover createion of new ami image based on state of machine 

## there will be 2 modules:
* creation_of_ec2_instance
    * in this module there will be ec2 instance with user data script that will install some extra packages in the init script
        * kubeadm, kubelet, kubectl all in latest version
* creation_of_ami_based_on_ec2_instance
    * in this module there will be ec2 instance, we will creare snaphost of instance from first module and then we create ami based on this snapshot and we will use it to create new instance with newly created ami 

