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

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_eventhub_namespace" "namespace" {
  name                = var.eventhub_namespace_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.eventhub_namespace_sku
  capacity            = var.eventhub_namespace_capacity

  lifecycle {
    ignore_changes = [
      zone_redundant,
      network_rulesets
    ]
  }
}

resource "azurerm_eventhub" "inputstream" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = data.azurerm_resource_group.rg.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
}

resource "azurerm_eventhub_authorization_rule" "listenrule" {
  name                = var.eventhub_listen_policy_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.inputstream.name
  resource_group_name = data.azurerm_resource_group.rg.name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_eventhub_authorization_rule" "sendrule" {
  name                = var.eventhub_send_policy_name
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = azurerm_eventhub.inputstream.name
  resource_group_name = data.azurerm_resource_group.rg.name

  listen = false
  send   = true
  manage = false
}


# Wyjście connection string (sensitive)
output "eventhub_connection_string" {
  value     = azurerm_eventhub_authorization_rule.sendrule.primary_connection_string
  sensitive = true
}
