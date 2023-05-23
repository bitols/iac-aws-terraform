output "network" {
  value = {
    vpc_id     = aws_vpc.main.id
    private_subnets = aws_subnet.private
    public_subnets = aws_subnet.public
    gw_id      = aws_internet_gateway.gw.id
    nat_ids    = aws_nat_gateway.nat.*.id
  }
}