output "alb_dns_name" {
  value = module.webserver_cluster.bharath_alb_name
  description = "The domain name of the load balancer"
}

