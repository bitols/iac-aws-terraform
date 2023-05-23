resource "aws_key_pair" "ssh_key" {
  key_name   = "my-keypair"
  public_key = file("${path.module}/my-keypair.pub")
}


resource "aws_instance" "private_instance" {
  count         = length(var.network.private_subnets)
  ami           = split(":", jsondecode(var.image).builds[0].artifact_id)[1] 
  instance_type = "t2.micro"
  subnet_id     = var.network.private_subnets[count.index].id
  key_name      = aws_key_pair.ssh_key.key_name
  tags          = merge(var.tags, { Name = "${var.name}-private-instance-${count.index + 1}" })

  # Add additional configuration as needed
}

resource "aws_instance" "bastion" {
  ami           = split(":", jsondecode(var.image).builds[0].artifact_id)[1] 
  instance_type = "t2.micro"
  subnet_id     = var.network.public_subnets[0].id
  key_name      = aws_key_pair.ssh_key.key_name
  tags          = merge(var.tags, { Name = "${var.name}-bastion" })

  # Add additional configuration as needed
}

resource "aws_lb" "load_balancer" {
  name               = "${var.name}-load-balancer"
  load_balancer_type = "application"
  subnets            = [for subnet in var.network.public_subnets : subnet.id]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  # Add additional configuration as needed
}