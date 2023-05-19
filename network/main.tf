resource "aws_vpc" "main" {
  cidr_block = var.Network_CIDR

  tags = {
    Name = var.Name
  }
}

resource "aws_subnet" "public" {
  count = var.N_subnets / 2

  cidr_block = cidrsubnet(var.Network_CIDR, 8, count.index)
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = var.N_subnets / 2

  cidr_block = cidrsubnet(var.Network_CIDR, 8, count.index + var.N_subnets / 2)
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-internet-gateway"
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.N_subnets / 2

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.private[count.index].id

  tags = {
    Name = "${var.Name}-nat-${count.index}"
  }
}

resource "aws_eip" "nat" {
  count = var.N_subnets / 2

  tags = {
    Name = "${var.Name}-eip-${count.index}"
  }
}

resource "aws_route_table" "public" {
  count = var.N_subnets / 2

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-public-route-table-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count = var.N_subnets / 2

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Name}-private-route-table-${count.index}"
  }
}

resource "aws_route" "public_to_internet" {
  count = var.N_subnets / 2

  route_table_id            = aws_route_table.public[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
  destination_prefix_list_id = null
}

resource "aws_route" "private_to_nat" {
  count = var.N_subnets / 2

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}