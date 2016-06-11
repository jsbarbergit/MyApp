variable "vpc_id" {}
variable "name" {}
variable "pri_subnets" {}
variable "azs" {}

#Create 2 private subnets
resource "aws_subnet" "private_subnets" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(split(",", var.pri_subnets), count.index)}"
	availability_zone = "${element(split(",", var.azs), count.index)}"
	count = 2
	tags = {
		Name = "${var.name}-PRI-${element(split(",", var.azs), count.index)}"
	}
}
output "subnet_ids" { value = "${join(",", aws_subnet.private_subnets.*.id)}" }
