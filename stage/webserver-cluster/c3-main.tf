# Create EC2 Instance
/*
resource "aws_instance" "my-ec2-vm" {
  ami           = var.ec2_ami_id 
  instance_type = var.ec2_instance_type
  key_name      = "terraform-key"
	user_data = file("apache-install.sh")  
  /*
    user_data     = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Welcome to StackSimplify ! AWS Infra created using Terraform</div></body></html>" > /var/www/html/index.html
    EOF
  */
  /*
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "web"
  }
}
*/
/*
# create a mysql resource
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  db_name             = "example_database"  # How should we set the username and password?
  username = "var.db_username"
  password = "var.db_password"
}
*/

resource "aws_launch_configuration" "demo-asg" {
  image_id        = "ami-022e1a32d3f742bd8"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.vpc-web.id]
  user_data = file("apache-install.sh")
   # Required when using a launch configuration with an ASG.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.demo-asg.name  
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-demo-asg-example"
    propagate_at_launch = true
  }
}
# Create a load balancer

resource "aws_lb" "demo-elb" {
  name               = "terraform-alb-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.vpc-web.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo-elb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "demo-listner-asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}