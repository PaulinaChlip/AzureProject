variable "resource_group_name" {
  description = "Name of existing Resource Group"
  type        = string
}

variable "eventhub_namespace_name" {
  description = "Name of the Event Hub Namespace"
  type        = string
}

variable "eventhub_namespace_sku" {
  description = "SKU for Event Hub Namespace"
  type        = string
  default     = "Basic"
}

variable "eventhub_namespace_capacity" {
  description = "Capacity units for Event Hub Namespace"
  type        = number
  default     = 1
}

variable "eventhub_name" {
  description = "Name of the Event Hub"
  type        = string
}

variable "eventhub_partition_count" {
  description = "Number of partitions for Event Hub"
  type        = number
  default     = 1
}

variable "eventhub_message_retention" {
  description = "Message retention in days"
  type        = number
  default     = 1
}

variable "eventhub_listen_policy_name" {
  description = "Name of the Listen authorization rule"
  type        = string
}

variable "eventhub_send_policy_name" {
  description = "Name of the Send authorization rule"
  type        = string
}
