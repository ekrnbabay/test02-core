
variable "PROJECTNAME" {
  default = "PRJ02"
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  version = "~> 2.0"
  name = "my-ecs"
  create_ecs = false
}



module "main-vpc" {
  source = "../modules/vpc"
  ENV = "env1"
  AWS_REGION = "${var.AWS_REGION}"
  VPC_TAG 		= var.VPC_TAG
  VPC_SG_TAG 	= var.VPC_SG_TAG
  INSTANCE_TYPE = var.INSTANCE_TYPE
}

module "main-role" {
  source = "../modules/role"
  ENV = "env1"
  PROJECTNAME = var.PROJECTNAME
}


output "aws_subnet_ids0" {
	value      = tolist(module.main-vpc.public_subnets)
}

output "role_1" {
	value      = module.main-role.masterprofile
}

output "aws_subnet_ids1" {
	value      = tolist(module.main-vpc.public_subnets)[0]
}



module "instances" {
  source = "../modules/instances"
  ENV = "env1"
  VPC_ID = "${module.main-vpc.vpc_id}"
  PROJECTNAME = var.PROJECTNAME

  PUBLIC_SUBNET = tolist(module.main-vpc.public_subnets)[0]
  INSTANCE_TYPE = var.INSTANCE_TYPE
  INGRES_SCIDR_BLOCK = var.INGRES_SCIDR_BLOCK
  MASTERPROFILE = module.main-role.masterprofile
  INGRES_SCIDR_GITHOOK = var.INGRES_SCIDR_GITHOOK
}
