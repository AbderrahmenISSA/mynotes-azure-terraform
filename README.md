- Create public and private key
-- ssh-keygen -o
-- Enter file in which to save the key : azure_rsa

- SSH VM
-- ssh -i ~/.ssh/azure_rsa azadmin@168.63.121.255

- Connect via Mysql Workbench
-- Host : mynote-sqlserver.mysql.database.azure.com
-- User : mynoteapp@mynote-sqlserver
-- Password : $var.mysql_admin_password