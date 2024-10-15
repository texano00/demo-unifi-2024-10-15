## GENERIC ##
variable "account_id" {
  type = string
}
variable "env" {
  type = string
}
variable "region" {
  type = string
}

variable "allowed_ips" {
  description = "List of IPs allowed to access the EC2 instance on SSH and HTTP (port 5000)"
  type        = list(string)
  default     = [] # Replace with specific IPs for more security
}