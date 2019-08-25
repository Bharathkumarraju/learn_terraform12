output "bharath_alb_name" {
  value = aws_lb.bharaths_ALB.dns_name
  description = "The domain name of the LoadBalancer"
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.bharaths_ASG.name
  description = "The name of the autoscaling group"
}

output "alb_security_group_id" {
  value = aws_security_group.bharaths_alb_securitygroup.id
  description = "The ID of the security group attached to the Load balnacer"
}