provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

module "vpc" {
	source ="../module_vpc"
	name = "${var.project}-${var.env}"
	cidr = "${var.vpc_cidr}"

}	

module "pub_subnets" {
	source = "../module_pub_subnets"
	vpc_id = "${module.vpc.vpc_id}"
	name = "${var.project}-${var.env}"
	pub_subnets = "${var.pub_subnets}"
	azs = "${var.azs}"
}

module "pri_subnets" {
	source = "../module_pri_subnets"
	vpc_id = "${module.vpc.vpc_id}"
	name = "${var.project}-${var.env}"
	pri_subnets = "${var.pri_subnets}"
	azs = "${var.azs}"
}

#Outputs

# VPC
output "vpc_id"   { value = "${module.vpc.vpc_id}" }
output "vpc_cidr" { value = "${module.vpc.vpc_cidr}" }

#Subnets
output "pub_subnet_ids" { value = "${module.pub_subnets.subnet_ids}" }
output "pri_subnet_ids" { value = "${module.pri_subnets.subnet_ids}" }
