output "bharath_alb_name" {
  value = aws_lb.bharaths_ALB.dns_name
  description = "The domain name of the LoadBalancer"
}

