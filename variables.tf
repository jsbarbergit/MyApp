#Default region
variable "aws_region" {
	description = "Default AWS Region"
	default = "eu-west-1"
}
#VPC Name
variable "vpc_name" {
	default = "MyAPP"
}
#VPC Cidr Block
variable "cidr_block" {
	default = "10.100.0.0/16"
}
