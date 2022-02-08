# ALB configuration
resource "aws_lb" "holm-service" {
    name               = "holm-service-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb-sg.id]
    subnets            = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]

    tags = {
        Name = "Holm-service-lb"
    }
}

# ALB target group
resource "aws_lb_target_group" "holm-service-fancypage" {
    name     = "holm-service-lb-tg"
    port     = 4345
    protocol = "HTTP"
    vpc_id   = aws_vpc.DEV.id

    health_check {
      interval            = 5
      path                = "/ping/index.html"
      port                = 4345
      protocol            = "HTTP"
      timeout             = 3
      healthy_threshold   = 3
      unhealthy_threshold = 2
    }

    target_type = "instance"

    tags = {
        Name = "Holm-service lb tg"
    }
}

# ALB target group
resource "aws_lb_target_group" "holm-service-nosofancypage" {
    name     = "holm-service-nosofancypage-lb-tg"
    port     = 4346
    protocol = "HTTP"
    vpc_id   = aws_vpc.DEV.id

    health_check {
      interval            = 5
      path                = "/ping/index.html"
      port                = 4346
      protocol            = "HTTP"
      timeout             = 3
      healthy_threshold   = 3
      unhealthy_threshold = 2
    }

    target_type = "instance"

    tags = {
        Name = "Holm-service lb tg"
    }
}

# ALB listener
resource "aws_lb_listener" "holm-service-fancy" {
    load_balancer_arn = aws_lb.holm-service.arn
    port              = "4345"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.holm-service-fancypage.arn
    }
}

# ALB listener
resource "aws_lb_listener" "holm-service-notsofancy" {
    load_balancer_arn = aws_lb.holm-service.arn
    port              = "4346"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.holm-service-nosofancypage.arn
    }
}

# Alb listener rules
resource "aws_lb_listener_rule" "fancypage_url" {
    listener_arn = aws_lb_listener.holm-service-fancy.arn
    priority     = 100

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.holm-service-fancypage.arn
    }

    condition {
        http_header {
            http_header_name = "url"
            values           = ["https://fancypage.holmbank.ee/"]
        }
    }
}

resource "aws_lb_listener_rule" "notsofancypage_url" {
    listener_arn = aws_lb_listener.holm-service-notsofancy.arn
    priority     = 100

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.holm-service-nosofancypage.arn
    }

    condition {
        http_header {
            http_header_name = "url"
            values           = ["https://privatlyfancy.holmbank.ee"]
        }
    }
}

# ALB target group attachment
resource "aws_lb_target_group_attachment" "holm-service-fancy" {
    target_group_arn = aws_lb_target_group.holm-service-fancypage.arn
    target_id        = aws_instance.holm-services.id
    port             = 4345
}

# ALB target group attachment
resource "aws_lb_target_group_attachment" "holm-service-notsofancy" {
    target_group_arn = aws_lb_target_group.holm-service-nosofancypage.arn
    target_id        = aws_instance.holm-services.id
    port = 4346
}