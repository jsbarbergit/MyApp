variable "vpc_id" {}
variable "name" {}
variable "pri_subnets" {}
variable "azs" {}
variable "size" {}

#Create Route Table with default gw
resource "aws_route_table" "rt" {
        vpc_id = "${var.vpc_id}"
        tags = {
	        Name = "${var.name}-PRI-RT"
	}
}

#Create 2 private subnets
resource "aws_subnet" "private_subnets" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(split(",", var.pri_subnets), count.index)}"
	availability_zone = "${element(split(",", var.azs), count.index)}"
	count = "${var.size}"
	tags = {
		Name = "${var.name}-PRI-${element(split(",", var.azs), count.index)}"
	}
}

#Associate RT with Network
resource "aws_route_table_association" "rtassoc" {
        subnet_id = "${element(split(",",join(",", aws_subnet.private_subnets.*.id)), count.index)}"
        route_table_id = "${aws_route_table.rt.id}"
        count = "${var.size}"
}

output "subnet_ids" { value = "${join(",", aws_subnet.private_subnets.*.id)}" }
