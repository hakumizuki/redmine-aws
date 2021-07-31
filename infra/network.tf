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
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.vpc_cidr_network}.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_region.current.name}a"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public-a"
    },
  )
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  # Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public-a"
    },
  )
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

# Public Subnet C
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${local.vpc_cidr_network}.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_region.current.name}c"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public-c"
    },
  )
}

resource "aws_route_table" "public_c" {
  vpc_id = aws_vpc.main.id

  # Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-public-c"
    },
  )
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_c.id
}

###################################################
# Private Subnets - Outbound Internet Access Only #
###################################################
# Availability Zone A
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${local.vpc_cidr_network}.10.0/24"
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-private-a"
    },
  )
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-private-a"
    },
  )
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# Availability Zone C
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${local.vpc_cidr_network}.11.0/24"
  availability_zone = "${data.aws_region.current.name}c"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-private-c"
    },
  )
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-private-c"
    },
  )
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}