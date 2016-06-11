variable "vpc_id" {}
variable "name" {}
variable "pub_subnets" {}
variable "azs" {}

#Create 2 public subnets - will use zone0 and zone1 as defined in variables.tf
resource "aws_subnet" "public_subnets" {
	vpc_id = "${var.vpc_id}"
	cidr_block = "${element(split(",", var.pub_subnets), count.index)}"
	availability_zone = "${element(split(",", var.azs), count.index)}"
	count = 2
	tags = {
		Name = "${var.name}-PUB-${element(split(",", var.azs), count.index)}"
	}
}

output "subnet_ids" { value = "${join(",", aws_subnet.public_subnets.*.id)}" }
