resource "azurerm_resource_group" "myrg_deploy" {
    name = "MyNotes-Dev"
    location = var.az_location
}
