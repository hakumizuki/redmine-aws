resource "aws_lb" "app" {
  name               = "${local.prefix}-main"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id,
  ]

  security_groups = [aws_security_group.lb.id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "app" {
  name        = "${local.prefix}-app"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
  port        = 80
}

resource "aws_lb_target_group_attachment" "redmine" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.redmine.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "redmine-2" {
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.redmine-2.id
  port             = 80
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "app_https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"

  # Use aws_acm_certificate_validation instead of aws_acm_certificate
  # to ensure that the validation will be created by Terraform even
  # though aws_acm_certificate.arn has the same arn
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_security_group" "lb" {
  description = "Allow access to Application Load Balancer"
  name        = "${local.prefix}-lb"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
