#Set Provider and region
provider = "aws" {
	region = "${var.aws_region}"
}

#Create the MyApp VPC
resource "aws_vpc" "${var.vpc_name}" {
	cidr_block = "${var.vpc_cidr}"
}
