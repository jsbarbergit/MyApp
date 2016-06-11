/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

/* Define our vpc */
resource "aws_vpc" "MyApp-PROD" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags { 
	  Name = "MyAPP-PROD-VPC" 
       }
}

resource "aws_subnet" "MyApp-PROD-PUB-NET-1A" {
	vpc_id = "${aws_vpc.MyApp-PROD.id}"
	cidr_block = "${var.net_prod_pub_1a}"
	availability_zone = "eu-west-1a"
	tags {
		Name = "MyApp-PROD-PUB-NET-1A"
	}
}
resource "aws_subnet" "MyApp-PROD-PUB-NET-1B" {
	vpc_id = "${aws_vpc.MyApp-PROD.id}"
	cidr_block = "${var.net_prod_pub_1b}"
	availability_zone = "eu-west-1b"
	tags {
		Name = "MyApp-PROD-PUB-NET-1B"
	}
}
resource "aws_subnet" "MyApp-PROD-PRI-NET-1A" {
	vpc_id = "${aws_vpc.MyApp-PROD.id}"
	cidr_block = "${var.net_prod_pri_1a}"
	availability_zone = "eu-west-1a"
	tags {
		Name = "MyApp-PROD-PRI-NET-1A"
	}
}
resource "aws_subnet" "MyApp-PROD-PRI-NET-1B" {
	vpc_id = "${aws_vpc.MyApp-PROD.id}"
	cidr_block = "${var.net_prod_pri_1b}"
	availability_zone = "eu-west-1b"
	tags {
		Name = "MyApp-PROD-PRI-NET-1B"
	}
}
