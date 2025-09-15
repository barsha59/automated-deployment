output "web_eip" {
  description = "Elastic IP of the web server"
  value       = aws_eip.web_eip.public_ip
}

output "web_instance_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}
