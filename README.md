Welcome to the My Note APP repository! Please follow the steps below to get started.

## Table of Contents
- [SSH Key Generation](#ssh-key-generation)
- [Connect to VM via SSH](#connect-to-vm-via-ssh)
- [Connect to MySQL Workbench](#connect-to-mysql-workbench)
- [Create an App registrations (Service Principal)](#app-registrations)
- [Azure Container Registry](#azure-container-registry)
- [Scripts Configuration](#scripts-configuration)

## SSH Key Generation
Generate a public and private key using the following command:

```bash
ssh-keygen -o -f ~/.ssh/azure_rsa
```
## Connect to VM via SSH
Connect to your VM using the generated SSH key:
```bash
ssh -i ~/.ssh/azure_rsa azadmin@168.63.121.255
```
## Connect to MySQL Workbench 
- Try using these creds in order to connect to MySQL Server via Workbench
  - Host: `mynote-sqlserver.mysql.database.azure.com`
  - User: `mynoteapp@mynote-sqlserver`
  - Password: `$var.mysql_admin_password`
 
## App Registrations
1. Create App registrations in the Azure portal.
2. Save the `SecretID` and `Value` for later use.

## Azure Container Registry
1. In the Azure Container Registry (ACR), go to Access Control (IAM).
2. Add a reader role for the previously created App.
3. Retrieve the Login server from the Overview section in ACR: `"Name.azurecr.io"`

## Scripts Configuration
Update the following variables in **frontEndScript.sh** and **backendScript.sh**:

```bash
### frontEndScript.sh
ACR_REGISTRY="Name.azurecr.io"
ACR_SP_ID="SecretID"
ACR_SP_SECRET="Value"
```

```bash
### backendScript.sh
ACR_REGISTRY="Name.azurecr.io"
ACR_SP_ID="SecretID"
ACR_SP_SECRET="Value"
``` 

