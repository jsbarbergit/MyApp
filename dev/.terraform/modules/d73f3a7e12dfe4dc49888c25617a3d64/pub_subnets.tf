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
		Name = "${var.name}-NET-PUB-RT" 
	}
}

#Create 2 public subnets - will use zone0 and zone1 as defined in variables.tf
resource "aws_subnet" "public_subnets" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(split(",", var.pub_subnets), count.index)}"
	availability_zone = "${element(split(",", var.azs), count.index)}"
	count = "${var.size}"
	tags = {
		Name = "${var.name}-NET-PUB-${element(split(",", var.azs), count.index)}"
	}
}

#Associate RT with Network
resource "aws_route_table_association" "rtassoc" {
	subnet_id = "${element(split(",",join(",", aws_subnet.public_subnets.*.id)), count.index)}"
	route_table_id = "${aws_route_table.rt.id}"
	count = "${var.size}"
}

#Create an EIP for use with NAT Gateway
resource "aws_eip" "natgw" {
	vpc = true
}

#Create NAT Gateway in 1st subnet only
resource "aws_nat_gateway" "natgw" {
	allocation_id = "${aws_eip.natgw.id}"
	subnet_id = "${aws_subnet.public_subnets.0.id}"
	depends_on = ["aws_internet_gateway.gw"]
}

output "subnet_ids" { value = "${join(",", aws_subnet.public_subnets.*.id)}" }
output "natgw_id" { value = "${aws_nat_gateway.natgw.id}" }
