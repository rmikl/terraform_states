resource "aws_lb" "network_lb" {
  name               = "network-load-balancer"
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.default_vpc_subnets_ids.ids
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "agents_80" {
  load_balancer_arn = aws_lb.network_lb.arn
  protocol = "TCP"
  port     = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agents_80.arn
  }
}

resource "aws_lb_listener" "agents_81" {
  load_balancer_arn = aws_lb.network_lb.arn
  protocol = "TCP"

  port     = 81

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agents_81.arn
  }
}

resource "aws_lb_target_group" "agents_80" {
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default_vpc.id

}
resource "aws_lb_target_group" "agents_81" {
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default_vpc.id

}

resource "aws_lb_target_group_attachment" "group1_att" {
  target_group_arn = aws_lb_target_group.agents_80.arn
  target_id        = aws_instance.root1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "group2_att" {
  target_group_arn = aws_lb_target_group.agents_81.arn
  target_id        = aws_instance.root2.id
  port             = 80
}