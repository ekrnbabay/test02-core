variable "ENV" {}
variable "AWS_REGION" {}
variable "VPC_TAG" {}
variable "VPC_SG_TAG" {}
variable "INSTANCE_TYPE" {}


variable "iam_role" {
  description = "IAM Role to be used"
  default = "ADD_ROLE"
}
##----------------------------
#     Get VPC Variables
##----------------------------

#-- Get VPC ID
data "aws_vpc" "selected" {
  tags = {
    Name = var.VPC_TAG
  }
}

#-- Get All Subnet List
data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.selected.id}"
  
}

#-- Get Public Subnet List
data "aws_subnet_ids" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Tier = "public"
  }
}


#--- Gets Security group with tag specified by var.VPC_SG_TAG
data "aws_security_group" "selected" {
  tags = {
    Name = var.VPC_SG_TAG
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${data.aws_vpc.selected.id}"
}

output "security_group" {
  description = "The security_group of the VPC"
  value       = data.aws_security_group.selected
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = data.aws_subnet_ids.all.ids
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = data.aws_subnet_ids.selected.ids
}




