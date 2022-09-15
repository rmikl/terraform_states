# rds-1 scenario

## 1 RDS mySQL and one read replica

create 1 RDS mysql and one read replica within SingleAZ

im passing secretes via env variables:
export TF_VAR_username=<the username>
export TF_VAR_password=<the password>

IMPORTANT NOTE:
there is no possibility to use `terraform destroy` in this scenario due to:
https://github.com/hashicorp/terraform-provider-aws/issues/769