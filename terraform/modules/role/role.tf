variable "ENV" {}
variable "PROJECTNAME" {}


resource "aws_iam_role" "test_role" {
  name = "${var.PROJECTNAME}_role_${var.ENV}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

output "RoleName" {
  value = "${aws_iam_role.test_role.name}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.PROJECTNAME}_profile_${var.ENV}"
  role = "${aws_iam_role.test_role.name}"
}

output "masterprofile" {
  value = "${aws_iam_instance_profile.test_profile.name}"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "${var.PROJECTNAME}_policy_${var.ENV}"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "policyname" {
  value = "${aws_iam_role_policy.test_policy.name}"
}




