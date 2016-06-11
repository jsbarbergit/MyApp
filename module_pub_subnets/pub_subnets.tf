variable "vpc_id" {}
variable "name" {}
variable "pub_subnets" {}
variable "azs" {}
variable "size" {}
variable "vpc_cidr" {}

#Create IGW
resource "aws_internet_gateway" "gw" {
	vpc_id = "${var.vpc_id}"
}

#Create Route Table with default gw
resource "aws_route_table" "rt" {
	vpc_id = "${var.vpc_id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gw.id}"
	}
	tags = {
		Name = "${var.name}-PUB-RT" 
	}
}

#Create 2 public subnets - will use zone0 and zone1 as defined in variables.tf
resource "aws_subnet" "public_subnets" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(split(",", var.pub_subnets), count.index)}"
	availability_zone = "${element(split(",", var.azs), count.index)}"
	count = "${var.size}"
	tags = {
		Name = "${var.name}-PUB-${element(split(",", var.azs), count.index)}"
	}
}

#Associate RT with Network
resource "aws_route_table_association" "rtassoc" {
	subnet_id = "${element(split(",",join(",", aws_subnet.public_subnets.*.id)), count.index)}"
	route_table_id = "${aws_route_table.rt.id}"
	count = "${var.size}"
}

output "subnet_ids" { value = "${join(",", aws_subnet.public_subnets.*.id)}" }
