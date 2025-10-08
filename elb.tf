resource "aws_lb" "backend_alb" {
  name               = "noteapp-backend-alb"
  internal           = false # Internet-facing or internal(private)
  load_balancer_type = "application"
  subnets            = local.public_subnet_set
}

resource "aws_lb_target_group" "noteapp_backend_tg" {
  name        = "noteapp-backend-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.noteapp_vpc.id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Accepts incoming connection. (From 443 or HTTPS)
resource "aws_lb_listener" "noteapp_alb_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:${data.aws_region.current_region.id}:${data.aws_caller_identity.current.account_id}:certificate/5494ac12-bba2-45c4-9ca6-575bc9b0c97c"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.noteapp_backend_tg.arn
  }
}