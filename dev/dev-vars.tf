variable "project" {
	description = "Project Name"
	default = "MyApp"
}

variable "env" {
	description = "Environment"
	default = "DEV"
}

variable "size" {
	description = "Used to specify no. of subnets and AZs"
	default = "2"
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
  default     = "10.190.0.0/16"
}

#Variables with multiple elemnets stored as comma sep'd strings to pass through modules
#which don;t currently support maps
variable "azs" {
	default= "eu-west-1a,eu-west-1b,eu-west-1c"
}

variable "pub_subnets" {
	default = "10.190.0.0/24,10.190.1.0/24,10.190.2.0/24"
}

variable "pri_subnets" {
	default = "10.190.10.0/24,10.190.11.0/24,10.190.12.0/24"
}

#Key pair name
variable "key_name" {
	default = "jb-bjss-keypair"
}

#AMI ID & size of Web Server
variable "web_ami" {
	default = "ami-c39604b0"
}
variable "web_size" {
	default = "t2.micro"
}

#WEB ASG Settings
variable "asg_max" {
	default = "1"
}
variable "asg_min" {
	default = "1"
}
