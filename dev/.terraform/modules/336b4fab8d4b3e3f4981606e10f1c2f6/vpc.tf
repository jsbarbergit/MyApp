variable "name" {}
variable "cidr" {}

#Define the vpc
resource "aws_vpc" "new-vpc" {
	
  	cidr_block = "${var.cidr}"
  	enable_dns_hostnames = true
  	tags { 
		Name = "${var.name}-VPC" 
       	}
}

#Define Public SGs for ELB
resource "aws_security_group" "pubsg" {
	name = "${var.name}-PUB-SG"
	vpc_id = "${aws_vpc.new-vpc.id}"
	description = "Public ELB Allow inbound HTTP from anywhere"
	#HTTP from Anywhere
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	#Allow outbound access
	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags {
		Name = "${var.name}-PUB-SG"
	}
}

#Define Private SG Rule
resource "aws_security_group" "prisg" {
	name = "${var.name}-PRI-SG"
	vpc_id = "${aws_vpc.new-vpc.id}"
	description = "Private allow inbound HTTP from Pub SG"
	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
	}
	tags {
		Name = "${var.name}-PRI-SG"
	}
}
#Add the rules for the Pri SG - use source sg id
#TF reqs this to be done as a sep sg rule rather than in the sg def
resource "aws_security_group_rule" "prisg-rule" {
	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	security_group_id = "${aws_security_group.prisg.id}"
	source_security_group_id = "${aws_security_group.pubsg.id}"
}


output "vpc_id" { value = "${aws_vpc.new-vpc.id}" }
output "vpc_cidr" { value = "${aws_vpc.new-vpc.cidr_block}" }
output "vpc_pubsg" { value = "${aws_security_group.pubsg.id}" }
output "vpc_prisg" { value = "${aws_security_group.prisg.id}" }
