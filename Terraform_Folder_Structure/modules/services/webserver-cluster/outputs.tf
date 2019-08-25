output "bharath_alb_name" {
  value = aws_lb.bharaths_ALB.dns_name
  description = "The domain name of the LoadBalancer"
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bharaths_ASG.name
  description = "The name of the autoscaling group"
}
