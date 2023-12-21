variable "subscription_id" {
  description = "Azure Subscription ID"
  default     = "2f70ea30-d0b7-40b8-8aa2-a0bbb69923c2" #Ahed
  # default     = "40423b54-8d08-4ff3-8628-c78e663f8353" #Abderrahmen

}

variable "az_location" {
  description = "Azure Location"
  default     = "westeurope"
}

variable "APP_NAME" {
  description = "Application Name"
  default     = "MyNotes"
}

########################### VNET Config ###############################
variable "VNET_CIDR" {
  type    = list(any)
  default = ["192.168.0.0/16"]
}

variable "PUBLIC_SUBNETS_CIDR" {
  type    = list(any)
  default = ["192.168.1.0/24"]
}

variable "PRIVATE_SUBNETS_CIDR" {
  type    = list(any)
  default = ["192.168.11.0/24"]
}

########################### FRONTEDN VM ###############################
variable "FRONTEND_VM_SIZE" {
  default = "Standard_DS1_v2"
}

variable "FRONTEND_USER" {
  description = "Frontend Username"
  default = "ahed"
}

variable "FRONTEND_VM_OS_DISK" {
  default = "myFrontendOsDisk"
}

variable "FRONTEND_HOSTNAME" {
  default = "notesFrontend"
}


########################### Backend VM ###############################
variable "BACKEND_VM_SIZE" {
  default = "Standard_DS1_v2"
}

variable "BACKEND_USER" {
  description = "Backend Username"
  default = "ahed"
}

variable "BACKEND_VM_OS_DISK" {
  default = "myBackendOsDisk"
}


variable "BACKEND_HOSTNAME" {
  default = "notesBackend"
}


########################### Mysql Server ###############################
variable "mysql_admin_login" {
  default = "mynoteapp"
}

variable "mysql_admin_password" {
  default = "M@ve2C!0ud2024"
}
