data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "redmine" {
  name               = "${local.prefix}-server"
  assume_role_policy = file("./ec2-instance/instance-profile-policy.json")

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "redmine" {
  name = "${local.prefix}-redmine-instance-profile"
  role = aws_iam_role.redmine.name
}

resource "aws_instance" "redmine" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./ec2-instance/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.redmine.name
  key_name             = "grw-easy-infra"
  subnet_id            = aws_subnet.public_a.id
  private_ip           = "${local.vpc_cidr_network}.1.10"

  vpc_security_group_ids = [
    aws_security_group.redmine.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-server"
    },
  )
}

# resource "aws_eip" "redmine" {
#   vpc = true

#   instance                  = aws_instance.redmine.id
#   associate_with_private_ip = "${local.vpc_cidr_network}.1.10"
#   depends_on                = [aws_internet_gateway.main]
# }

resource "aws_instance" "redmine-2" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  user_data            = file("./ec2-instance/user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.redmine.name
  key_name             = "grw-easy-infra"
  subnet_id            = aws_subnet.public_c.id
  private_ip           = "${local.vpc_cidr_network}.2.10"

  vpc_security_group_ids = [
    aws_security_group.redmine.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-server"
    },
  )
}

# resource "aws_eip" "redmine-2" {
#   vpc = true

#   instance                  = aws_instance.redmine-2.id
#   associate_with_private_ip = "${local.vpc_cidr_network}.2.10"
#   depends_on                = [aws_internet_gateway.main]
# }

resource "aws_security_group" "redmine" {
  description = "Control server inbound and outbound access"
  name        = "${local.prefix}-server"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
