output "network" {
  value = {
    vpc_id     = aws_vpc.main.id
    subnet_ids = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
    gw_id      = aws_internet_gateway.gw.id
    nat_ids    = aws_nat_gateway.nat.*.id
  }
}