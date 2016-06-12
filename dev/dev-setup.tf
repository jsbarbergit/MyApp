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
	natgw = "${module.pub_subnets.natgw_id}"
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

#Define Launch Config
resource "aws_launch_configuration" "web_lc" {
	name = "${var.project}-${var.env}-PRI-WEB-LC"
	image_id = "${var.web_ami}"
	instance_type = "${var.web_size}"
	key_name = "${var.key_name}"
	security_groups = [ "${module.vpc.vpc_prisg}" ]
	lifecycle {
		create_before_destroy = true
	}
	user_data = "${file("web_data.sh")}"
}

#Create a list of AZs - based on count var
resource "null_resource" "azs" {
	count = "${var.size}"
	triggers {
		az = "${element(split(",", var.azs), count.index)}"
	}
}

#ASG
resource "aws_autoscaling_group" "web_asg" {
	availability_zones = [ "${null_resource.azs.*.triggers.az}" ]
#	availability_zones = [ "${element(split(",", var.azs), count.index)}" ]
	name = "${var.project}-${var.env}-PRI-WEB-ASG"
	max_size = "${var.asg_max}"
	min_size = "${var.asg_min}"
	desired_capacity = "${var.asg_min}"
	load_balancers = [ "${aws_elb.pubelb.name}" ]
	launch_configuration = "${aws_launch_configuration.web_lc.name}"
	vpc_zone_identifier = [ "${module.pri_subnets.subnet_ids}" ]
	tag {
		key = "Name"
		value = "${var.project}-${var.env}-PRI-WEB-EC2"
		propagate_at_launch = "true"

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

#ELB
output "elb-dns" { value = "${aws_elb.pubelb.dns_name}" }
