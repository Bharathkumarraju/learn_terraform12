output "Address" {
  value = aws_db_instance.bharaths_mysql.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value = aws_db_instance.bharaths_mysql.port
  description = "The Port the database is listening on"
}

