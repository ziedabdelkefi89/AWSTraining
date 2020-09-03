resource "aws_launch_configuration" "launchconfig" {
  name_prefix     = "launchconfig"
  image_id        = var.AMIS
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.allow-ssh-bastion.id]
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance bastion"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "autoscaling_ldap" {
  name                      = "autoscaling ldap"
  vpc_zone_identifier       = [aws_subnet.main-public-5.id, aws_subnet.main-public-6.id]
  launch_configuration      = aws_launch_configuration.launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance ldap"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "autoscaling_www" {
  name                      = "autoscaling www"
  vpc_zone_identifier       = [aws_subnet.main-public-3.id, aws_subnet.main-public-4.id]
  launch_configuration      = aws_launch_configuration.launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance www"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "autoscaling_app" {
  name                      = "autoscaling app"
  vpc_zone_identifier       = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
  launch_configuration      = aws_launch_configuration.launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance app"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "autoscaling_db" {
  name                      = "autoscaling db"
  vpc_zone_identifier       = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
  launch_configuration      = aws_launch_configuration.launchconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance db"
    propagate_at_launch = true
  }
}


resource "aws_launch_configuration" "elb-launchconfig" {
  name_prefix     = "elb-launchconfig"
  image_id        = var.AMIS
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.www_ssh.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "elb-autoscaling" {
  name                      = "elb-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-3.id, aws_subnet.main-public-4.id]
  launch_configuration      = aws_launch_configuration.elb-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.www-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}