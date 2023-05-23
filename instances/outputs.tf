# Output variables
output "private_instances_ips" {
  value = { for i, instance in aws_instance.private_instance : instance.tags.Name => instance.private_ip }
}

output "bastion_host_ip" {
  value = aws_instance.bastion.public_ip
}

output "load_balancer_http_dns" {
  value = aws_lb.load_balancer.dns_name
}
