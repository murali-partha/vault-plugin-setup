variable "id" {
  description = "The unique identifier for the resource"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the Vault server"
  type        = string
  default     = "m5.large"
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume in GiB"
  type        = number
  default     = 64
}

variable "log_level" {
  description = "Log level for Vault (e.g., 'info', 'debug')"
  type        = string
  default     = "info"
}

variable "vault_version" {
  description = "The version of Vault to install"
  type        = string
  default     = "1.20.1"
  
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  
}