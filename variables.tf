variable "subscription_id" {
  description = "Azure Subscription ID"
  default     = "40423b54-8d08-4ff3-8628-c78e663f8353"
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

