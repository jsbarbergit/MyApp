variable "project" {
	description = "Project Name"
	default = "MyApp"
}

variable "env" {
	description = "Environment"
	default = "PROD"
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
	default = "10.180.0.0/24,10.180.1.0/24,10.180.2.0/24"
}

variable "pri_subnets" {
	default = "10.180.10.0/24,10.180.11.0/24,10.180.12.0/24"
}
