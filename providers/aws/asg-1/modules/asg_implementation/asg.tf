resource "aws_launch_template" "asg_target_1" { 
  name_prefix   = "asg_t1"
  image_id = var.ec2_ami
  instance_type = var.aws_instance
  user_data = filebase64("modules/asg_implementation/scripts/install_script.sh")
  vpc_security_group_ids = [  aws_security_group.traffic_to_ec2.id ]
}

resource "aws_autoscaling_group" "asg_t1" {
  availability_zones = [var.zone1,var.zone2]
  desired_capacity   = 1
  max_size           = 10
  min_size           = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  
  launch_template {
    id      = aws_launch_template.asg_target_1.id
  }

  tags = [
    {
      key                 = "name"
      value               = "asg_t1"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_attachment" "asg_attachment" {
   autoscaling_group_name = aws_autoscaling_group.asg_t1.id
   alb_target_group_arn   = aws_lb_target_group.group1.id
 }

resource "aws_autoscalingplans_scaling_plan" "asg_t1" {
  name = "asg_t1"

  application_source {
    tag_filter {
      key    = "name"
      values = ["asg_t1"]
    }
  }

  scaling_instruction {
    max_capacity       = 3
    min_capacity       = 0
    resource_id        = format("autoScalingGroup/%s", aws_autoscaling_group.asg_t1.name)
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"
    service_namespace  = "autoscaling"

    target_tracking_configuration {
      predefined_scaling_metric_specification {
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 70
    }
  }
}