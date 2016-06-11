variable "project" {
	description = "Project Name"
	default = "MyApp"
}

variable "env" {
	description = "Environment"
	default = "DEV"
}

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

#Variables with multiple elemnets stored as comma sep'd strings to pass through modules
#which don;t currently support maps
variable "azs" {
	default= "eu-west-1a,eu-west-1b,eu-west-1c"
}

variable "pub_subnets" {
	default = "10.180.100.0/24,10.180.101.0/24,10.180.102.0/24"
}

variable "pri_subnets" {
	default = "10.180.110.0/24,10.180.111.0/24,10.180.112.0/24"
}
