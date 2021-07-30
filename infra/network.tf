resource "aws_vpc" "main" {
  cidr_block           = "${local.vpc_cidr_network}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-vpc"
    },
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-main"
    },
  )
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.vpc_cidr_network}.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_region.current.name}a"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public"
    },
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public"
    },
  )
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Dummy Subnet
resource "aws_subnet" "dummy" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.vpc_cidr_network}.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_region.current.name}c"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-dummy"
    },
  )
}

resource "aws_route_table" "dummy" {
  vpc_id = aws_vpc.main.id

  # Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-dummy"
    },
  )
}

resource "aws_route_table_association" "dummy" {
  subnet_id      = aws_subnet.dummy.id
  route_table_id = aws_route_table.dummy.id
}