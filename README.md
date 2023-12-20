Azure Resource Provisioning using Terraform 
===========


This Terraform code deploys a basic infrastructure on Azure, including a Vnet, subnets, NSG, VM, and a MySQL server.

Azure Login
-----

```hcl
az login
```

Make sure to customize Input Variables
----------------------

- `subscription_id` - Azure Subscription ID
- `admin_password` - Admin password for virtual machines and MySQL server
- `mysql_admin_password` - Admin password for MySQL server

Steps
=======

```hcl
cd azure-terraform
terraform init
terraform plan
terraform apply -var-file=terraform.tfvars -auto-approve
```

