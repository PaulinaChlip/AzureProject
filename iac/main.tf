terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "iad-lab-rg"
  # ZMIANA: Zaktualizowano region na dostępny w subskrypcji studenckiej
  location = "Poland Central"
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "iadlabstorage${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally-redundant storage (najtańsza opcja)
}

# Event Hub Namespace
resource "azurerm_eventhub_namespace" "namespace" {
  name                = "pc414961namespace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  capacity            = 1
  
  lifecycle {
    ignore_changes = [
      zone_redundant,
      network_rulesets
    ]
  }
}

# Event Hub w namespace
resource "azurerm_eventhub" "inputstream" {
  name                = "inputstream"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 1
  message_retention   = 1
}

# Authorization Rule do nasłuchu (Listen)
resource "azurerm_eventhub_authorization_rule" "listenrule" {
  name                = "parkingdatastreamanalytics_eventhubinput_policy"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.inputstream.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = true
  send   = false
  manage = false
}

# Authorization Rule do wysyłki (Send)
resource "azurerm_eventhub_authorization_rule" "sendrule" {
  name                = "myparkingadmin"
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.inputstream.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = false
  send   = true
  manage = false
}



# Wyjście connection string (sensitive)
output "eventhub_connection_string" {
  value     = azurerm_eventhub_authorization_rule.sendrule.primary_connection_string
  sensitive = true
}
