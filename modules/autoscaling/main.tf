resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.env}-launch-template"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-instance"
    }
  }
}

resource "aws_lb" "web_lb" {
  name               = "${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids  # Now supports multiple subnets
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.env}-asg"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.web_tg.arn]
  health_check_type         = "EC2"
  force_delete              = true
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web_lb.dns_name
}
