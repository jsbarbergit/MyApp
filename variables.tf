variable "access_key" { 
  description = "AWS access key"
}

variable "secret_key" { 
  description = "AWS secret access key"
}

variable "region"     { 
  description = "AWS region to host your network"
  default     = "eu-west-1" 
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.180.0.0/16"
}

variable "net_prod_pub_1a" {
  description = "Public Subnet for Prod AZ 1A"
  default = "10.180.0.0/24"
}
variable "net_prod_pub_1b" {
  description = "Public Subnet for Prod AZ 1B"
  default = "10.180.1.0/24"
}
variable "net_prod_pri_1a" {
  description = "Private Subnet for Prod AZ 1A"
  default = "10.180.100.0/24"
}
variable "net_prod_pri_1b" {
  description = "Private Subnet for Prod AZ 1B"
  default = "10.180.101.0/24"
}
