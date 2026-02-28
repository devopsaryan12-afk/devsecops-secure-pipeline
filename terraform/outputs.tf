output "production" {
  value = aws_instance.web.public_ip
}