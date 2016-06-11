variable "name" {}
variable "cidr" {}

#Define the vpc
resource "aws_vpc" "new-vpc" {
	
  	cidr_block = "${var.cidr}"
  	enable_dns_hostnames = true
  	tags { 
		Name = "${var.name}" 
       	}
}

output "vpc_id" { value = "${aws_vpc.new-vpc.id}" }
output "vpc_cidr" { value = "${aws_vpc.new-vpc.cidr_block}" }
