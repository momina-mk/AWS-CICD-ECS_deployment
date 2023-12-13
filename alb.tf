resource "aws_lb" "this" {
  name               = "this"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb.id]
}

# Specifying target group for listner on port 80
resource "aws_lb_target_group" "blue" {
  name        = "blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = "30"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

}

resource "aws_lb_target_group" "green" {
  name        = "green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = "30"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

}
# Load Balancer Listener (HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}
resource "aws_lb_listener" "p8080" {
  load_balancer_arn = aws_lb.this.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.green.id
    type             = "forward"
  }
}