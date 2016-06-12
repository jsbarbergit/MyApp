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
	vpc_cidr = "${module.vpc.vpc_cidr}"
	name = "${var.project}-${var.env}"
	size = "${var.size}"
	pub_subnets = "${var.pub_subnets}"
	azs = "${var.azs}"
}

module "pri_subnets" {
	source = "../module_pri_subnets"
	vpc_id = "${module.vpc.vpc_id}"
	name = "${var.project}-${var.env}"
	size = "${var.size}"
	pri_subnets = "${var.pri_subnets}"
	azs = "${var.azs}"
}

#Define ELB
resource "aws_elb" "pubelb" {
	name = "${var.project}-${var.env}-PUB-ELB" 
	subnets = [ "${split(",", module.pub_subnets.subnet_ids)}" ]
	security_groups = [ "${split(",", module.vpc.vpc_pubsg)}" ]
	listener {
		instance_port = 80
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}
}


#Outputs

# VPC
output "vpc_id"   { value = "${module.vpc.vpc_id}" }
output "vpc_cidr" { value = "${module.vpc.vpc_cidr}" }
output "vpc_pubsg" { value = "${module.vpc.vpc_pubsg}" }
output "vpc_prisg" { value = "${module.vpc.vpc_prisg}" }

#Subnets
output "pub_subnet_ids" { value = "${module.pub_subnets.subnet_ids}" }
output "pri_subnet_ids" { value = "${module.pri_subnets.subnet_ids}" }
