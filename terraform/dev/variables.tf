variable "AWS_ACCESS_KEY" {
  default = "access key"
}

variable "AWS_SECRET_KEY" {
  default = "aws secret key"
}

variable "AWS_REGION" {
  default = "aws - REGION"
}

variable "VPC_TAG" {
  description = "Set the Name Tag used for filtering specific VPC"
  default = "TestVPC"
}
variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "VPC_SG_TAG" {
  description = "Set the Name Tag used for filtering specific Security Groups"
  default = "TestVPC"
}


variable "INGRES_SCIDR_BLOCK" {
  default = ["*.*.224.55/32","172.31.0.0/20","*.247.221.53/32"]
}

# for WebHook Jenkinsport 8080
#GET /meta from github
#curl https://api.github.com/meta
variable "INGRES_SCIDR_GITHOOK" {
  default = ["*.206.224.55/32","172.31.0.0/20","*.247.221.53/32","192.30.252.0/22","185.199.108.0/22","140.82.112.0/20"]
}

