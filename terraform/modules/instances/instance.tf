variable "ENV" {}

variable "INGRES_SCIDR_BLOCK" {}

variable "INGRES_SCIDR_GITHOOK" {}

variable "INSTANCE_TYPE" {}

variable "PROJECTNAME" {}

variable "MASTERPROFILE" {}

variable "VPC_ID" {}

variable "PUBLIC_SUBNET" {}

variable "KEYPATH" {
	default = "C:\\testdoc\\AWS\\aws_firsttest.pem"
}

resource "aws_security_group" "allow_ssh_new" {
  vpc_id      = "${var.VPC_ID}"
  name        = "allow-ssh-${var.ENV}"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.INGRES_SCIDR_BLOCK
  }
  ingress {
		from_port   = 443
		to_port     = 443
		protocol =   "tcp"
		cidr_blocks =  var.INGRES_SCIDR_BLOCK
	  }
  ingress {
		from_port   = 8080
		to_port     = 8080
		protocol =   "tcp"
		cidr_blocks =  var.INGRES_SCIDR_GITHOOK
	  }
  ingress {
		from_port   = 80
		to_port     = 80
		protocol =   "tcp"
		cidr_blocks =  var.INGRES_SCIDR_BLOCK
	  }
  ingress {
		from_port = 8
		to_port = 0
		protocol = "icmp"
		cidr_blocks =  var.INGRES_SCIDR_BLOCK
  }	  
  tags = {
    Name         = "allow-ssh"
    Environmnent = "${var.ENV}"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "shell-script" {
  #template = "${file("..\\scripts\\init_slave.sh")}"
  template = "${file("..\\scripts\\init_empty.sh")}"
  vars = {
    ENV = "${var.ENV}"
  }
}

data "template_cloudinit_config" "cloudinit" {

  gzip = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.shell-script.rendered}"
  }
}

#resource "aws_key_pair" "deployer" {
#  key_name   = "aws_firsttest"
#}   

resource "aws_network_interface" "jenmaster" {
  subnet_id = var.PUBLIC_SUBNET
  private_ips = ["172.31.1.10"]
  security_groups = ["${aws_security_group.allow_ssh_new.id}"]
}

resource "aws_network_interface" "jenslave" {
  subnet_id = var.PUBLIC_SUBNET
  private_ips = ["172.31.1.15"]
  #security_group_id = ["${aws_security_group.allow_ssh_new.id}"]
  security_groups = ["${aws_security_group.allow_ssh_new.id}"]

}
resource "aws_network_interface" "netqa" {
  subnet_id = var.PUBLIC_SUBNET
  private_ips = ["172.31.1.20"]
  #security_group_id = ["${aws_security_group.allow_ssh_new.id}"]
  security_groups = ["${aws_security_group.allow_ssh_new.id}"]

}
resource "aws_network_interface" "netdev" {
  subnet_id = var.PUBLIC_SUBNET
  private_ips = ["172.31.1.25"]
  #security_group_id = ["${aws_security_group.allow_ssh_new.id}"]
  security_groups = ["${aws_security_group.allow_ssh_new.id}"]

}

resource "aws_instance" "master" {
  #ami           = "${data.aws_ami.ubuntu.id}"
  ami = "ami-04b49c3e1a37205b5" # my instans Ubuntu18JenkinsAspNetDocker
  instance_type = "${var.INSTANCE_TYPE}"

  # the VPC subnet
  #subnet_id = var.PUBLIC_SUBNET
  network_interface {
     network_interface_id = "${aws_network_interface.jenmaster.id}"
	 
     device_index = 0
   } 
  # the security group
  #vpc_security_group_ids = ["${aws_security_group.allow_ssh_new.id}"]

  # the public SSH key
  key_name = "aws_firsttest"
  
  #role
  iam_instance_profile = "${var.MASTERPROFILE}"
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  provisioner "local-exec" {
      command = "echo private_ip= ${aws_instance.master.private_ip} >> master_ips.txt"
  }
  
  provisioner "local-exec" {
      command = "echo public_ip= master_${aws_instance.master.public_ip} >> master_ips.txt"
  }

  provisioner "file" {
    source = "..\\scripts\\init_master.sh"
    destination = "/home/ubuntu/init_master.sh"
  }
  provisioner "file" {
    source = "..\\jenkinsfile\\jenkins-cli.jar"
    destination = "/home/ubuntu/jenkins-cli.jar"
  }
  provisioner "file" {
    source = var.KEYPATH
    destination = "/home/ubuntu/.ssh/aws_firsttest.pem"
  }
  
  provisioner "remote-exec" {
    inline = [
	  "sleep 20",
      "sudo echo 'testconnection' > connectiontest.file",
	  "chmod 400 /home/ubuntu/.ssh/aws_firsttest.pem",
	  "mkdir -p /home/ubuntu/jenkins",
	  "sudo chown -R  ubuntu /home/ubuntu/jenkins",
	  "ssh-keygen -f '/home/ubuntu/.ssh/known_hosts' -R '172.31.1.15'",
      "chmod +x /home/ubuntu/init_master.sh",
	  "sed -i -e 's/\r$//' init_master.sh",
	  "./init_master.sh",
      "echo COMPLETED"
    ]
  }
 


  connection {
    host = "${aws_instance.master.public_ip}"
    user = "ubuntu"
	timeout = "2m"
    private_key = "${file("${var.KEYPATH}")}"
  }
  tags = {
    Name         = "${var.PROJECTNAME}-JSmaster-${var.ENV}"
    Environmnent = "${var.ENV}"
  }
}


resource "aws_instance" "slave" {
  #ami           = "${data.aws_ami.ubuntu.id}"
  ami = "ami-04b49c3e1a37205b5" # my instans Ubuntu18_04JenkinsAspNetDocker
  instance_type = "${var.INSTANCE_TYPE}"

  # the VPC subnet
  #subnet_id = var.PUBLIC_SUBNET
  network_interface {
     network_interface_id = "${aws_network_interface.jenslave.id}"
     device_index = 0
   } 
  # the security group
  #vpc_security_group_ids = ["${aws_security_group.allow_ssh_new.id}"]

  # the public SSH key
  key_name = "aws_firsttest"
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  provisioner "local-exec" {
     command = "echo private_ip= ${aws_instance.slave.private_ip} >> slave_ips.txt"
  }
  provisioner "local-exec" {
     command = "echo public_ip = ${aws_instance.slave.public_ip} >> slave_ips.txt"
  }
   
  #user_data = "${data.template_cloudinit_config.cloudinit.rendered}"
  provisioner "file" {
    source = "..\\scripts\\init_slave.sh"
    destination = "/home/ubuntu/init_slave.sh"
  }
  provisioner "file" {
    source = "..\\jenkinsfile\\jenkins-cli.jar"
    destination = "/home/ubuntu/jenkins-cli.jar"
  }
  provisioner "file" {
    source = var.KEYPATH
    destination = "/home/ubuntu/.ssh/aws_firsttest.pem"
  }
  
  provisioner "remote-exec" {
    inline = [
	  "sleep 10",
      "sudo echo 'testconnection' > connectiontest.file",
	  "chmod 400 /home/ubuntu/.ssh/aws_firsttest.pem",
	  "mkdir -p /home/ubuntu/jenkins",
	  "sudo chown -R  ubuntu /home/ubuntu/jenkins",
	  "ssh-keygen -f '/home/ubuntu/.ssh/known_hosts' -R '172.31.1.20'",
	  "ssh-keygen -f '/home/ubuntu/.ssh/known_hosts' -R '172.31.1.25'",
      "chmod +x /home/ubuntu/init_slave.sh",
	  "sed -i -e 's/\r$//' init_slave.sh",
	  "./init_slave.sh",
      "echo COMPLETED"
    ]
  }
 


  connection {
    host = "${aws_instance.slave.public_ip}"
    user = "ubuntu"
	timeout = "2m"
    private_key = "${file("${var.KEYPATH}")}"
  }
  
  tags = {
    Name         = "${var.PROJECTNAME}-JSslave-${var.ENV}"
    Environmnent = "${var.ENV}"
  }
}



resource "aws_instance" "QA" {
  #ami           = "${data.aws_ami.ubuntu.id}"
  ami = "ami-04b49c3e1a37205b5" # my instans Ubuntu18_04JenkinsAspNetDocker
  instance_type = "${var.INSTANCE_TYPE}"

  # the VPC subnet
  #subnet_id = var.PUBLIC_SUBNET
  network_interface {
     network_interface_id = "${aws_network_interface.netqa.id}"
     device_index = 0
   } 
  # the security group
  #vpc_security_group_ids = ["${aws_security_group.allow_ssh_new.id}"]

  # the public SSH key
  key_name = "aws_firsttest"
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  provisioner "local-exec" {
     command = "echo private_ip = ${aws_instance.QA.private_ip} >> QA_ips.txt"
  }
  provisioner "local-exec" {
     command = "echo public_ip = ${aws_instance.QA.public_ip} >> QA_ips.txt"
  }
   
  #user_data = "${data.template_cloudinit_config.cloudinit.rendered}"
  
  tags = {
    Name         = "${var.PROJECTNAME}-QA-${var.ENV}"
    Environmnent = "${var.ENV}"
  }
}


resource "aws_instance" "DEV" {
  #ami           = "${data.aws_ami.ubuntu.id}"
  ami = "ami-04b49c3e1a37205b5" # my instans Ubuntu18_04JenkinsAspNetDocker
  instance_type = "${var.INSTANCE_TYPE}"

  # the VPC subnet
  #subnet_id = var.PUBLIC_SUBNET
  network_interface {
     network_interface_id = "${aws_network_interface.netdev.id}"
     device_index = 0
   } 
  # the security group
  #vpc_security_group_ids = ["${aws_security_group.allow_ssh_new.id}"]

  # the public SSH key
  key_name = "aws_firsttest"
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  provisioner "local-exec" {
     command = "echo private_ip = ${aws_instance.DEV.private_ip} >> DEV_ips.txt"
  }
  provisioner "local-exec" {
     command = "echo public_ip = ${aws_instance.DEV.public_ip} >> DEV_ips.txt"
  }
   
  user_data = "${data.template_cloudinit_config.cloudinit.rendered}"
  
  tags = {
    Name         = "${var.PROJECTNAME}-DEV-${var.ENV}"
    Environmnent = "${var.ENV}"
  }
}

output "ip" {
    value = "${aws_instance.master.public_ip}"
}

