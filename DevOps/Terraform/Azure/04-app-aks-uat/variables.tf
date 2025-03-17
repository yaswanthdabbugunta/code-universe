variable "resource_group_location" {
  type        = string
  description = "centralindia"
}
variable "resource_group_name_app" {
  type        = string
  description = "Resource Group - Application"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
